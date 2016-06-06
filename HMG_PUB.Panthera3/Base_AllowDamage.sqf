/*
null = [] spawn compile preprocessFileLineNumbers "Base_AllowDamage.sqf";
NSA_hp_Base_AllowDamage = compile preprocessFileLineNumbers "Base_AllowDamage.sqf";
[] spawn NSA_hp_Base_AllowDamage;
*/

if (isDedicated) exitWith {};

private ["_keepWatching"];

// waitUntil { sleep 0.13; (player getVariable ["NSA_plrInitDone", false]) };

_keepWatching = true;

// player allowDamage true;

while { (alive player) && ( _keepWatching ) } do {

	if (player inArea ("mrk_Base_" + str (player getVariable "NSA_plrSide")) ) then {
		
		player allowDamage false;
		hint "Player in safezone: player allowDamage false";
		
		waitUntil {
			sleep 1.02;
			
			if !(player inArea ("mrk_Base_" + str (player getVariable "NSA_plrSide")) ) exitWith { player allowDamage true; true };
			
			if !(alive player) exitWith { _keepWatching = false; true };	
		};
	
	};
	
	sleep 1.06;
};