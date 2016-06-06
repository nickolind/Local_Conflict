/*
		null = [] spawn compile preprocessFileLineNumbers "main_loop.sqf";
		NSA_hp_main_loop = compile preprocessFileLineNumbers "main_loop.sqf";



[NSA_param_gamePrepareTime, NSA_param_roundTime, NSA_param_respawnWave] spawn NSA_hp_main_loop;

*/


while {(NSA_hp_GameState != -1)} do {
	sleep 2;
	diag_log format ["testCRASH: 1"];	// testing
	[(_this select 0), (_this select 1), (_this select 2)] spawn NSA_hp_init_newRound;
	diag_log format ["testCRASH: 2"];	// testing
	waitUntil {
		sleep 1.04;
		
		(NSA_hp_roundTime > 0)
	};
	diag_log format ["testCRASH: 3"];	// testing
	
	waitUntil {
		sleep 1.04;
		
		// hint format ["wave:\n%1\n%2",NSA_hp_RespawnWave, ["hp_respWaveTime", "getTime"] call NSA_Timer];
		NSA_hp_RespawnWave set [1, ["hp_respWaveTime", "getTime"] call NSA_Timer ];
		NSA_hp_roundTime  = ["hp_roundTime", "getTime"] call NSA_Timer;
		
		
		if ((NSA_hp_RespawnWave select 1) <= 0) then {
			publicVariable "NSA_hp_RespawnWave";
			["hp_respWaveTime", "delete"] call NSA_Timer;
			
			sleep 5;
			waitUntil {sleep 0.2; (["hp_respWaveTime", "getTime"] call NSA_Timer) < 0 };
			
			[(_this select 2)] call NSA_hp_init_respawnWave;	// очистка объектов вал¤ющихс¤ на земле, респавн солдат и техники, новый таймер следующей волны.
			
		};
		
		(NSA_hp_roundTime <= 0)
	};
	
};





