/*
NSA_hp_CPtrgActivated = compile preprocessFileLineNumbers "CPtrgActivated.sqf";
[thisTrigger, thisList] spawn NSA_hp_CPtrgActivated;

Срабатывает, когда триггер зоны захвата активирован. 
Запускает процесс захвата зоны.

Выполняется только на сервере (т.к. триггер создан только там).

		Захват точек (в секунду):
			Для захвата - минимум 2ч в зоне (и на 1 больше обороны)
			Кап - 1000 очков
			Захват = (захватчики - обороняющиеся) * 3 + (БонусСквадов)
			БонСквадов = БонСквадов + (колво сосквадников)
			
			Если обороны больше - то же самое но на убывание (если зона принадлежит солдатам - значит знак минус)
			
			3 сквадных, 1 рандом - захват. 2 обороны:
				(4-2)*3 + 3 = +9 (111 секунд)


*/

private ["_sideOwner"];

_cp_thisTrigger = _this select 0;
_cp_thisList = _this select 1;
// _sideOwner = -1;


_UpdateCPOwner = {
	private ["_trg"];
	_trg = _this select 0;
	_owner = [east,west,resistance,sideLogic] find (_trg getVariable 'NSA_hp_CPOwner');
	_newOwner = -1;
	
	
	{
		if (_x >= 1000) then {
			_newOwner = _forEachIndex;
		};	
	} forEach (_trg getVariable 'NSA_hp_CapBar');
	
	if (_newOwner == -1) then {
		_newOwner = _owner;
	};
	
	_trg setVariable ["NSA_hp_CPOwner", [east,west,resistance,sideLogic] select _newOwner, false];
	(_trg getVariable "NSA_hp_CPMarker") setMarkerColor (["ColorEAST","ColorWEST","ColorGUER","ColorBlack"] select _newOwner);	
};


if (isNull _cp_thisTrigger) exitWith {};

while {triggerActivated _cp_thisTrigger} do {

								/*	Принцип захвата - в зоне подсчитывается число бойцов трех сторон (красных, синих и зеленых). Кого больше - захватывающая сторона. Обороняющая сторона - те, кому принадлежит зона. Далее сторона с численным перевесом (а значит захватывающая) начисляет на на свой счет очки захвата зоны. Когда они достигнут 1000 - зона будет захвачена.
								Скорость начисления зависит от количества бойцов-захватчиков (а если в зоне бойцы из одной группы - то к захвату добавляется бонус "за командные действия"), а так же от количества обороняющих (Кзахв. - Кобор = ~скорость захвата). Изначально зоны нейтральны и захватывать их будут те, кого в зоне больше.
								
								*/

								
/* ------------ Блок определения ------------
	
	Узнаем солдаты каких сторон в зоне захвата, подсчитываем их количество. Доминирующая сторона становится _sideCap. 
	_sideOp - сторона, противодействующая (уменьшает скорость зарабатывания очков захвата у доминирующей стороны).
*/

	_sideOwner = [east,west,resistance,sideLogic] find (_cp_thisTrigger getVariable 'NSA_hp_CPOwner');
	_sideCap = _sideOwner;		// Сторона чьих бойцов в зоне больше - становится стороной захватчиком
	_sideOp = _sideOwner;		
								// Сторона захватчик начисляет очки захвата на свой счет у текущей зоны
	
	_cpU = [0,0,0,0];			// _cpU - количество бойцов в зоне по сторонам -- [east,west,resistance,sideLogic]
	for '_y' from 0 to 2 do {
		_c = 	{
					(isPlayer _x) && (vehicle _x == _x) && (side _x == ([east,west,resistance] select _y))
				} count _cp_thisList;
		_cpU set [_y, _c];
	};
	
	for '_y' from 0 to 2 do {
		if ((_cpU select _y) > (_cpU select _sideCap)) then {_sideOp = _sideOwner; _sideCap = _y;};		
			// Если бойцов текущей в цикле стороны больше чем бойцов стороны _sideOwner - считать _y - захватчиками, а _sideOwner - обороняющей стороной
	};
	
	for '_y' from 0 to 2 do {
		if ( (_y != _sideCap) && ((_cpU select _y) > (_cpU select _sideOp)) ) then {_sideOp = _y;};
			// Если текущая в цикле сторона не самая многочисленная (не _sideCap), но ее людей больше чем текущей обороняющей стороны (_sideOp), то сделать эту сторону текущей обороняющей (как вторую по численности в зоне).
			// Это задел на возможность боя трех сторон одновременно.
	};
// ------------ Блок определения ------------	




/* ------------ Условный блок ------------
	
	Последние проверки перед началом изменения статуса захвата точки.
	Если нужные условия не соблюдены - выход из функции.
*/
	
	if (isNull _cp_thisTrigger) exitWith {};
	
	if ( (_cpU select _sideCap) == (_cpU select _sideOp) ) exitWith {};
	
	
	
	if (
		(_sideCap != _sideOwner)
		&&
		( ({(_x getVariable 'NSA_hp_CPOwner') == ([east,west,resistance] select _sideCap)} count (_cp_thisTrigger getVariable 'NSA_hp_connectedCPs')) <= 0 )
			
	) exitWith {};
		// Если доминирующая сторона не является владельцем точки (т.е. это захватчики) и при этом захватчики не владеют ни одной соседней связанной точкой - то текущую точку они захватывать не могут
	
	
// ------------ Условный блок ------------	
	
	
	
	
	
	
	
/* ------------ Блок изменения ------------
	
	Если условия соблюдены, то шкала захвата начинает изменяться - если захватчики доминируют в зоне - то идет уменьшение очков захвата других сторон (в том числе владельцев точки), а затем прирост очков захвата у захватчиков.
*/	
	
	_squadBonus = 0;
	_capUnits = [];
	_capGroups = [];
	
	{
		if ( (isPlayer _x) && (vehicle _x == _x) && (side _x == [east,west,resistance] select _sideCap) ) then {
			_capUnits pushBack _x;
			
			if !((group _x) in _capGroups) then {
				_capGroups pushBack (group _x);
			};
		};
	} forEach _cp_thisList;
	
	{
		_c = {(_x in _capUnits)} count units _x;
		if ( _c >= 2) then {_squadBonus = _squadBonus + _c};
	} forEach _capGroups;
	
	_timeDelta = serverTime - (_cp_thisTrigger getVariable ['NSA_hp_timeMark',serverTime - 0.5]);
	
	// _capDelta = (((_cpU select _sideCap) - (_cpU select _sideOp)) * 4 + (2 * _squadBonus)) * _timeDelta;
	_capDelta = (((_cpU select _sideCap) - (_cpU select _sideOp)) * 80 + (2 * _squadBonus)) * _timeDelta; 	// testing
	_cp_thisTrigger setVariable ['NSA_hp_timeMark', serverTime, false];
	
	// hint str _timeDelta;
	
	
	_CapBar = _cp_thisTrigger getVariable 'NSA_hp_CapBar';
	
	if ( ( (_CapBar select ((_sideCap + 1)%3)) + (_CapBar select ((_sideCap + 2)%3)) ) == 0 ) then {	// Если у других сторон очки захвата по нулям - начислять текущему захватчику очки ..
		
		_CapBar set [_sideCap, ((_CapBar select _sideCap) + _capDelta) min 1000];
	
	} else {																							// .. Иначе сперва вычитать очки захвата у обороняющих										
																										// (Принцип - сперва сбить захват противника, потом начать собственный захват)
		_CapBar set [((_sideCap + 1)%3), ((_CapBar select ((_sideCap + 1)%3)) - _capDelta) max 0];
		_CapBar set [((_sideCap + 2)%3), ((_CapBar select ((_sideCap + 2)%3)) - _capDelta) max 0];
		
			// Когда у обороняющих достигнут 0 - менять цвет зоны на черный (визуализация что зона теперь нейтральна)
		if ( ( (_CapBar select ((_sideCap + 1)%3)) + (_CapBar select ((_sideCap + 2)%3)) ) == 0 ) then {	
			_cp_thisTrigger setVariable ["NSA_hp_CPOwner", sideLogic, false];
		};
		
	};
	
	_cp_thisTrigger setVariable ['NSA_hp_CapBar', _CapBar, false];
	
	
	[_cp_thisTrigger] call _UpdateCPOwner;
	
// ------------ Блок изменения ------------
	
	
	
	
	
	sleep 0.5;
};

if (isNull _cp_thisTrigger) exitWith {};
_cp_thisTrigger setVariable ['NSA_hp_timeMark', nil, false];
_timeDelta = serverTime;

waitUntil {				// Если зону перестали захватывать - ждать еще Х секунд, а затем возвращать очки контроля стороне-владельцу.
	sleep 5;
	
	if (triggerActivated _cp_thisTrigger) exitWith { true };
	
	// if ((serverTime - _timeDelta) >= 60)  exitWith {
	if ((serverTime - _timeDelta) >= 10)  exitWith {	// testing
		for [{_i=0},{_i<=2},{_i=_i+1}] do {
			_j = 0;
			if (_i == _sideOwner) then { _j = 1000; };
			
			(_cp_thisTrigger getVariable 'NSA_hp_CapBar') set [_i, _j]; 
			
			[_cp_thisTrigger] call _UpdateCPOwner;
		};
		
		true
	};		
};
