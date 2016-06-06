// null = [] spawn compile preprocessFileLineNumbers "init_mission.sqf";
// NSA_hp_init_mission = compile preprocessFileLineNumbers "init_mission.sqf";
// [] spawn NSA_hp_init_mission;


NSA_hp_RoundsCount = 0;
NSA_hp_GameState = 1;
NSA_hp_roundTime = 0;


if (isServer) then {

	NSA_hp_PlayingSides = [false,false,false];	// [east,west,resistance]
	
	{
		if ( (playableSlotsNumber _x) > 0 ) then { NSA_hp_PlayingSides set [_forEachIndex, true] };
	} forEach [east,west,resistance];

	
	[] call NSA_hp_init_Spectators;

	
	[] spawn NSA_hp_main_loop;
	
};



if !(isDedicated) then {
	waitUntil {sleep 0.102; player == player };
	
	
	player setVariable ["NSA_plrSide", side group player];	
		// player setVariable ["NSA_plrSide", side group player, true];
	
	waitUntil { sleep 0.27; !(isNil{NSA_hp_RespawnWave}) };
	
	player setVariable ["NSA_plrInitDone", true];
};