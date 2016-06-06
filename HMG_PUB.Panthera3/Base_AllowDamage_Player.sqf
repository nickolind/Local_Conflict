/*
null = [] spawn compile preprocessFileLineNumbers "Base_AllowDamage_Player.sqf";
NSA_hp_Base_AllowDamage_Player = compile preprocessFileLineNumbers "Base_AllowDamage_Player.sqf";
[] spawn NSA_hp_Base_AllowDamage_Player;
*/

if (isDedicated) exitWith {};

private ["_keepWatching","_base"];

_keepWatching = true;

_base = NSA_hp_BaseTriggers select ([east,west,resistance] find (player getVariable "NSA_plrSide"));

while { (alive player) && ( _keepWatching ) } do {

	if (player inArea _base) then {
		
		player allowDamage false;
		hint "Player in safezone: player allowDamage false";
		
		waitUntil {
			sleep 1.02;
			
			if !(player inArea _base ) exitWith { player allowDamage true; true };
			
			if !(alive player) exitWith { _keepWatching = false; true };	
		};
	
	};
	
	sleep 1.06;
};