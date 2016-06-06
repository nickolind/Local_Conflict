/*
null = [] spawn compile preprocessFileLineNumbers "c_getCPstatus.sqf";
NSA_hp_c_getCPstatus = compile preprocessFileLineNumbers "c_getCPstatus.sqf";
[] spawn NSA_hp_c_getCPstatus;

	Клиентская функция.
	
	Когда боец заходит в зону - запросить у сервера статус этой зоны (владелец, шкала захвата) и обновлять ее каждые 2 секунды.
	
	*/

private["_waitForNewRound"];
	
_waitForNewRound = {
	waitUntil {
		sleep 1.01;
		if (!(isNil{NSA_hp_roundTime}) && !(isNil{NSA_hp_clientCapPoints})) then { 	
			if ((NSA_hp_roundTime > 0) && (count NSA_hp_clientCapPoints > 0)) exitWith {true} 	
		};
	};
};

// waitUntil { sleep 0.27; !(isNil{NSA_hp_clientCapPoints}) };		// Если будет продолжать появляться ошибка - убрать наверное функцию _waitForNewRound и написать waitUntil напрямую
	
	
while {(NSA_hp_GameState != -1)} do {			// if !(isNil{testing_stop}) exitWith{};
	if (isNil{NSA_hp_clientCapPoints}) then { [] call _waitForNewRound; };
	if (count NSA_hp_clientCapPoints < 1) then { [] call _waitForNewRound; };
	
	{
		if (player inArea (_x select 0)) then {
			//Отправляем запрос на сервер по текущему маркеру, кидаем обратно клиенту
			hint format ["%1\n\n%2", _x select 2, _x select 1 ];
		};
	} forEach NSA_hp_clientCapPoints;
	
	sleep 1;
};




