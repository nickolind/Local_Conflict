/*
null = [] call compile preprocessFileLineNumbers "init_respawnWave.sqf";
NSA_hp_init_respawnWave = compile preprocessFileLineNumbers "init_respawnWave.sqf";
[] call NSA_hp_init_respawnWave;

	Зачищаются валяющиеся на земле предметы.
	
	Ящики/машины с оборудованием на базах возвращаются на исходные позции (если целы. Если уничтожены - спавнятся заново).
*/

if !(isServer) exitWith {};

private ["_respawnWave"];


// Если боец в бессознанке - и тут же респавнить
{
	if ((isPlayer _x) && (_x getVariable ["ACE_isUnconscious",false])) then {
		_x setDamage 1;
		NSA_hp_forceRespawn = true;
		(owner _x) publicVariableClient "NSA_hp_forceRespawn";
		NSA_hp_forceRespawn = nil;
	};
} forEach PlayableUnits;


// Очистка всех объектов валяющихся на земле
[] spawn { 
	NSA_toDelete = [];
	{
		NSA_toDelete = NSA_toDelete + allMissionObjects (_x);
	} forEach ["GroundWeaponHolder", "WeaponHolderSimulated", "ACE_Explosive_Object", "ACE_M86PDM_Object", "ACE_BreachObject", "Default"];
	{
		deleteVehicle _x;
	} forEach NSA_toDelete;	
};




_respawnWave = _this select 0;
_waveNum = (NSA_hp_RespawnWave select 0) + 1;

// ["hp_respWaveTime", "delete"] call NSA_Timer;

["hp_respWaveTime", "create", _respawnWave] call NSA_Timer;
NSA_hp_RespawnWave = [_waveNum, _respawnWave];
publicVariable "NSA_hp_RespawnWave";
