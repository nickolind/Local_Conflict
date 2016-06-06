/*
		null = [] spawn compile preprocessFileLineNumbers "main_loop.sqf";
		NSA_hp_main_loop = compile preprocessFileLineNumbers "main_loop.sqf";



[_gamePrepareTime, _roundTime, _respawnWave] spawn NSA_hp_main_loop;

*/

private ["_gamePrepareTime","_roundTime","_respawnWave"];
													// NSA_hp_GameStarted -->  			120
													// NSA_hp_roundTime -->  			2400	(40mins)
													// NSA_hp_RespawnWaveTime -->  		600		(10mins)
NSA_gamePrepareTime 	= 60;
NSA_roundTime 			= 1200;
NSA_respawnWave 		= 60;


while {(NSA_hp_GameState != -1)} do {
	sleep 2;

	[NSA_gamePrepareTime, NSA_roundTime, NSA_respawnWave] spawn NSA_hp_init_newRound;
	
	waitUntil {
		sleep 1.04;
		
		(NSA_hp_roundTime > 0)
	};
	
	waitUntil {
		sleep 1.04;
		
		NSA_hp_RespawnWave set [1, ["hp_respWaveTime", "getTime"] call NSA_Timer ];
		NSA_hp_roundTime  = ["hp_roundTime", "getTime"] call NSA_Timer;

		if ((NSA_hp_RespawnWave select 1) <= 0) then {
			publicVariable "NSA_hp_RespawnWave";
			
			[NSA_respawnWave] call NSA_hp_init_respawnWave;	// ќчистка объектов вал€ющихс€ на земле, респавн солдат и техники, новый таймер следующей волны.
		};
		
		(NSA_hp_roundTime <= 0)
	};
	
};





