/*
null = [] spawn compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";
NSA_hp_publicVarsBroadcast = compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";
[] spawn NSA_hp_publicVarsBroadcast;


*/


waitUntil {
	sleep 1.03;
	( !(isNil {NSA_hp_GameStarted}) && !(isNil {NSA_hp_RespawnWave}) && !(isNil {NSA_hp_CapPoints}) )
};


// -------------- NSA_hp_GameStarted -------------- //
	[] spawn {
		while { true } do {
			if !(isNil{NSA_hp_GameStarted}) then {publicVariable "NSA_hp_GameStarted"};
			
			if (NSA_hp_GameState == -1) exitWith {};
			sleep 10;
		};
	};

	
// -------------- NSA_hp_RespawnWave -------------- //
	[] spawn {
		while { true } do {
			if !(isNil{NSA_hp_RespawnWave}) then {publicVariable "NSA_hp_RespawnWave"};
			
			if (NSA_hp_GameState == -1) exitWith {};
			sleep 10;
		};
	};

	
// -------------- Данные о точках захвата -------------- //
	[] spawn {
		private["_curRoundNum"];
		
		while { (NSA_hp_GameState != -1) } do {		//if !(isNil{testing_stop}) exitWith{};
			_curRoundNum = NSA_hp_RoundsCount;

			{
				[_x, _forEachIndex] spawn {
					private["_trg","_trgNum"];
					_trg = _this select 0;
					_trgNum = _this select 1;
					
					while { !(isNull _trg) } do {		//if !(isNil{testing_stop}) exitWith{};
						
						(NSA_hp_clientCapPoints select _trgNum) set [1, _trg getVariable "NSA_hp_CapBar"];
						(NSA_hp_clientCapPoints select _trgNum) set [2, _trg getVariable "NSA_hp_CPOwner"];
						
						if (triggerActivated _trg) then {
							
							{		
								if ((_x in crew _x) && (isPlayer _x) ) then {
									(owner _x) publicVariableClient "NSA_hp_clientCapPoints";								
								};
								
							} forEach list _trg;
						};
						sleep 1.95;
					};
				};
			} forEach NSA_hp_CapPoints;
			
			
			
			
			
			waitUntil {		//if !(isNil{testing_stop}) exitWith{};
				sleep 3.06;
				(NSA_hp_RoundsCount != _curRoundNum) && ( count NSA_hp_CapPoints == NSA_hp_CPnum )
			};

		};
	};