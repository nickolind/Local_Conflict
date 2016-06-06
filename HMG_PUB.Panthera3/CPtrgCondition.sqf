/*
// NSA_hp_CPtrgCondition = compile preprocessFileLineNumbers "CPtrgCondition.sqf";
// [thisTrigger, thisList] call NSA_hp_CPtrgCondition;

Код в Condition поле триггера зоны захвата. Проверяет что в триггер зашли игроки команды, не владеющей зоной. Если их больше опр. числа (2ч) - функция возвращает true в триггер и тот активируется, вызывая функцию NSA_hp_CPtrgActivated.

*/

_cp_thisTrigger = _this select 0;
_cp_thisList = _this select 1;

_cpU = [0,0,0,0];
for '_y' from 0 to 2 do {
	_c = 	{
				(isPlayer _x) && (vehicle _x == _x) && (side _x == ([east,west,resistance] select _y))
			} count _cp_thisList;
	_cpU set [_y, _c];
};

// _return = if ((((_cpU select 0) max (_cpU select 1)) max (_cpU select 2)) >= 2) then {
_return = if ((((_cpU select 0) max (_cpU select 1)) max (_cpU select 2)) >= 1) then {			// testing -- вернуть >= 2 -- т.е. нужно 2 ч для захвата зоны (а обороны должно быть меньше)
	true 
} else {
	false
};
	
_return
