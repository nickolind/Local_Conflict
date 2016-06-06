/*
null = [] spawn compile preprocessFileLineNumbers "Base_AllowDamage_AllOther.sqf";
NSA_hp_Base_AllowDamage_AllOther = compile preprocessFileLineNumbers "Base_AllowDamage_AllOther.sqf";
[] spawn NSA_hp_Base_AllowDamage_AllOther;

	Дописать блок неуязвимости техники на базах (после реализации респауна техники).
*/


if (isServer) then {
	{	 
		if !( isNull _x ) then {
			{
				_x allowDamage false;		// Для зданий - отслеживать не надо, они из триггера не уйдут, локальность не поменяют
			} forEach nearestObjects [position _x, ["all"], (triggerArea _x) select 0];
		};
	} forEach NSA_hp_BaseTriggers;
};


/*
	Блок для включения неуязвимости у техники, которая заехала в зону базы под управлением дружественного игрока

waitUntil {sleep 0.32; !isNil{NSA_hp_BaseTriggers}};

NSA_hp_Bases_Vehs = [];


// private ["_keepWatching"];

NSA_hp_keepWatching = true;

{	 
	if !( isNull _x ) then {
		while { ( NSA_hp_keepWatching ) } do {
			{
			if ( (count crew _x == 0) || () )
			} forEach list;
		};
	};
} forEach NSA_hp_BaseTriggers;

*/








// if ( (_x in vehicles) ) then {	// Для техники/ящиков - отслеживать и если покинет базу - вернуть уязвимость
				// if ( (_x isKindof "Ship" || _x isKindof "Air" || _x isKindof "LandVehicle" || _x isKindof "Thing") ) then {	//  || _x isKindof "Thing" 	// -- Ящики
				
					
					// _hph_EH = _x addEventHandler ["local", { 
						// if ( _this select 1 ) then {
							// [_this select 0] call NSA_hph_heliProtectHack;
						// };
					// }];

				// };
			// };
			
			
// (_x isKindof "Ship" || _x isKindof "Air" || _x isKindof "LandVehicle")


















/*
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

*/