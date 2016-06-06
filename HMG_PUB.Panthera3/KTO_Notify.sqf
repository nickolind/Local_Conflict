/*
	null = [thislist, thisTrigger] execVM "KTO_Notify.sqf";
*/

if (isServer) then {

	private ["_thisList","_tName","_objList","_grpList","_tHight","_cveh","_isInGrp","_y","_z"];
	
	_thisList = _this select 0;	
	_tName = _this select 1;

	_tHight = 300;
	_objList = [];															//  	<-----------------------Список имен объектов ВПИСЫВАТЬ СЮДА (если вручную)
	_grpList = [];
	
	while {triggerActivated _tName} do {
		{
			_cveh = list _tName select _forEachIndex;
			
			if ( !(_cveh in _objList) && ( (getPosATL _cveh select 2) <= _tHight ) ) then {		//Проверка на машину-контейнер-безопасности - не учитывать ее и всех пассажиров, если она в списке	
				
				for [{_y=0},{_y<(count (crew _cveh))},{_y=_y+1}] do {			//скан списка пассажиров юнита, вошедшего в триггер. Если юнит это транспорт - массив экипажа. Если это боец - он сам.
					_isInGrp = false;
				
					for [{_z=0},{_z<(count _grpList)},{_z=_z+1}] do {
						if ((crew _cveh select _y) in units (_grpList select _z)) exitWith {_isInGrp = true};
					}; 
					
					if ( !(_isInGrp) && !((crew _cveh select _y) in _objList) ) then {			//если не пренадлежит избранной группе и не является юнитом из списка исключений _objList, то наказать
	
						if ((crew _cveh select _y) getVariable "NSA_KTO_Sent" != 0) exitWith {}; 		//Если у текущего юнита статус sentinel = 1, значит этого юнита уже обрабатывает скрипт - выходим из цикла
							
						(crew _cveh select _y) setVariable ["NSA_KTO_Sent", -1, true];
						[[[_tName, _cveh, crew _cveh select _y, _tHight],"KTO_Not_Exe.sqf"],"BIS_fnc_execVM", crew _cveh select _y] call BIS_fnc_MP;
					};
				};
			};
		} forEach _thisList;	//скан списка юнитов, вошедших в триггер
		sleep 1;
	};
			
			
};