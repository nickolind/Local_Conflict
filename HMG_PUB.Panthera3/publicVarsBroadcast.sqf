/*
null = [] spawn compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";
NSA_hp_publicVarsBroadcast = compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";
[] spawn NSA_hp_publicVarsBroadcast;
*/


waitUntil {
	sleep 1.03;
	( !(isNil {NSA_hp_GameStarted}) && !(isNil {NSA_hp_RespawnWave}) )
};


// -------------- NSA_hp_GameStarted -------------- //
	[] spawn {
		while { true } do {
			publicVariable "NSA_hp_GameStarted";
			
			if (NSA_hp_GameStarted <= 0) exitWith {};
			sleep 10;
		};
	};

	
// -------------- NSA_hp_RespawnWave -------------- //
	[] spawn {
		while { true } do {
			publicVariable "NSA_hp_RespawnWave";
			
			if (NSA_hp_GameState == -1) exitWith {};
			sleep 10;
		};
	};