/*
null = [] call compile preprocessFileLineNumbers "init_respawnWave.sqf";
NSA_hp_init_respawnWave = compile preprocessFileLineNumbers "init_respawnWave.sqf";
[] call NSA_hp_init_respawnWave;

	Зачищаются валяющиеся на земле предметы.
	
	Ящики/машины с оборудованием на базах возвращаются на исходные позции (если целы. Если уничтожены - спавнятся заново).
*/

if !(isServer) exitWith {};

private ["_respawnWave"];

_respawnWave 		= _this select 0;

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



// Если боец в бессознанке - убивать (без фейд аута и надписи Убийца), и тут же респавнить
["hp_respWaveTime", "delete"] call NSA_Timer;

NSA_hp_RespawnWave = [
	(NSA_hp_RespawnWave select 0) + 1, 
	_respawnWave
];
publicVariable "NSA_hp_RespawnWave";

["hp_respWaveTime", "create", (NSA_hp_RespawnWave select 1)] call NSA_Timer;

