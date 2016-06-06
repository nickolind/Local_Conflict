/*
null = [] spawn compile preprocessFileLineNumbers "init_newRound.sqf";
NSA_hp_init_newRound = compile preprocessFileLineNumbers "init_newRound.sqf";
[] spawn NSA_hp_init_newRound;




	Заново выбираются точки отыгрыша 
		(в зависимости от количества игроков)
	
	Удаляются старые и создаются новые машины и ящики с оборудованием на базах
	
	Удаляется старая и создается новая техника сторон (в зависимости от количества игроков)
	
	Выбирается рандомное время (между утром и поздним полуднем) и погода (облачность).
		// Выбор рандомной облачности (дождь 0-10% (при обл 70+), время суток между 7 и 19
*/


if !(isServer) exitWith {};

private ["_gamePrepareTime","_roundTime","_respawnWave","_winner","_score"];

_gamePrepareTime 	= _this select 0;
_roundTime 			= _this select 1;
_respawnWave 		= _this select 2;



_winner = [NSA_hp_RoundsCount] call NSA_hp_setSidesScore;
_score = [];
{
	if (_x) then {
		_score pushBack (NSA_hp_SidesScore select _forEachIndex);
	} else {
		_score pushBack -1;
	};
} forEach NSA_hp_PlayingSides;

{
	if ( (isPlayer _x) ) then {
		[[ [_winner, _score], {							
			titleCut ["", "BLACK OUT", 0];
			[format["<t color='#FFFFFF' size = '1.0'>Раунд завершен<br/>Победа стороны %1</t>",(_this select 0)],0,0.1,10,0.7,0,708] call bis_fnc_dynamictext;
			[format["<t color='#FFFFFF' size = '0.8'>Счет:<br/><t color='#FFFFFF' size = '1.2'>%1</t></t>",(_this select 1)],0,0.5,10,0.7,0,707] call bis_fnc_dynamictext;

		}],"BIS_fnc_call", _x] call BIS_fnc_MP;
	};
} forEach playableUnits;



NSA_hp_RoundsCount = NSA_hp_RoundsCount + 1;
if (NSA_hp_RoundsCount > 10) then {
											// finish mission, server restart needed!
};
diag_log format ["NSA_hp_RoundsCount = %1",NSA_hp_RoundsCount];	// testing



/* --------------------------- Очистка --------------------------- */

["initRound", "delete"] call NSA_Timer;
["hp_roundTime", "delete"] call NSA_Timer;
["hp_respWaveTime", "delete"] call NSA_Timer;

NSA_hp_GameStarted = _gamePrepareTime;
NSA_hp_RespawnWave = [0, NSA_hp_GameStarted];
publicVariable "NSA_hp_GameStarted";
publicVariable "NSA_hp_RespawnWave";

{
	if (alive _x) then {
		_x setDamage 1;
	};
} forEach PlayableUnits;

/* --------------------------- Очистка --------------------------- */

sleep 2;

/* --------------------------- Изменения времени и погоды --------------------------- */
private ["_newTime","_newWeather","_vx","_vy","_vz","_va","_vb","_vc","_vd","_h","_m"];

if (isNil{NSA_hp_dawn_dusk}) then { NSA_hp_dawn_dusk = (date) call NSA_fnc_sun; };	// [[6,52],[15,19]] --  format: [dawnTime, duskTime ]
_vx = (NSA_hp_dawn_dusk select 0 select 0);
_vy = (NSA_hp_dawn_dusk select 1 select 0) - 3; // -3 чтобы начало миссии не приходилось на сумерки, так что через час уже будет ночь. Расчет на то, что миссия не будет длиться дольше Х часов.
_h = _vx + (floor random ( abs(_vy - _vx) ));

_vx = [(NSA_hp_dawn_dusk select 0 select 0), (NSA_hp_dawn_dusk select 0 select 1)];
_vy = [_h, (floor random 60)];
_m = if ((call compile format ["%1%2", _vx select 0, _vx select 1]) < (call compile format ["%1%2", _vy select 0, _vy select 1])) then {
	_vy select 1;
} else {
	_vx select 1;
};

_newTime = +date;	// format: [2014,6,24,11,0]
_newTime set [3, _h];
_newTime set [4, _m];

_va = random [0,0.5,1];
_vb = 0 max (0.25 - random ((_va - 0.6) max 0)); // if overcast > 0.6 --> rain chance 38% ; maxRain < 0.15
_vc = 0 max (0.15 - random ((_va - 0.8) max 0));	// if overcast > 0.8 --> lightning chance 5%
_vd = random (0.02 + (0.01 * _va) + (0.02 * ((NSA_hp_dawn_dusk select 0 select 0)) / _h) );	// 0 to 0.2 + (0.1 of overcast) + 0.2 * the closer time to sun_dawn (dew+humidity)
_newWeather = [_va,_vb, _vc, _vd]; // [overcast, rain, lightning, fog]

[[_newTime, _newWeather],"NSA_hp_setWeather"] call BIS_fnc_MP;

/* --------------------------- Изменения времени и погоды --------------------------- */


[] call NSA_hp_CP_Init;		// Пересоздать точки захвата
diag_log format ["testCRASH: 7"];	// testing

sleep 10;

diag_log format ["testCRASH: 7.1"]; // testing





["initRound", "create", NSA_hp_GameStarted] call NSA_Timer;

waitUntil { 
	sleep 1;
	
	NSA_hp_GameStarted = ["initRound", "getTime"] call NSA_Timer;
	NSA_hp_RespawnWave set [1, NSA_hp_GameStarted];
		
	(NSA_hp_GameStarted <= 0)
};

[] call {
															// ["hmg_msv_rifleman","hmg_infantry_msv_base","SoldierEB","CAManBase","Man","Land","AllVehicles","All"]
	
	{
		deleteVehicle _x;
	} forEach allDeadMen;
};


NSA_hp_roundTime = _roundTime;
publicVariable "NSA_hp_roundTime";

[_respawnWave] call NSA_hp_init_respawnWave;

["hp_roundTime", "create", NSA_hp_roundTime] call NSA_Timer;


	
	

if !(isDedicated) then {

};