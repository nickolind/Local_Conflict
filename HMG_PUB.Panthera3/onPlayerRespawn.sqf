private ["_newPlayer","_oldPlayer","_justConnected"];

_newPlayer = _this select 0;
_oldPlayer = _this select 1;
_justConnected = if (isNull _oldPlayer) then {true} else {false};

if (_justConnected) then {				// ----- Заход игрока на сервер (JIP или на старте)
	// hint ("GAME START -- INIT "+ str _this);
	
	waitUntil { sleep 0.13; (player getVariable ["NSA_plrInitDone", false]) };
	
	
} else {									// ----- Обычный респаун игрока
	// hint ("NOT a game init " + str _this);

	
	};

["Terminate"] call BIS_fnc_EGSpectator;

setPlayerRespawnTime (15 max (NSA_hp_RespawnWave select 1));

_newPlayer allowDamage false;

[] spawn {
	sleep 5;
	
	[] spawn NSA_hp_Base_AllowDamage;
};



_newPlayer setVariable ["NSA_KTO_Sent", 0, true];
_newPlayer setVariable ["NSA_KT_Sent", 0, true];