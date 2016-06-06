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

private ["_gamePrepareTime","_roundTime","_respawnWave"];

_gamePrepareTime 	= _this select 0;
_roundTime 			= _this select 1;
_respawnWave 		= _this select 2;

NSA_hp_RoundsCount = NSA_hp_RoundsCount + 1;
if (NSA_hp_RoundsCount > 10) then {
											// finish mission, server restart needed!
};



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




[] call NSA_hp_CP_Init;		// Пересоздать точки захвата


sleep 10;


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