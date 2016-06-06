/*
null = [] call compile preprocessFileLineNumbers "setSidesScore.sqf";
NSA_hp_setSidesScore = compile preprocessFileLineNumbers "setSidesScore.sqf";
[] call NSA_hp_setSidesScore;

	
	--> NSA_hp_init_newRound
	Серверная функция 
	
	Вычисляет, какая сторона победила по итогам раунда, начисляет победителю победное очко, обновляет NSA_hp_SidesScore

	Возвращает: сторону, победившую в раунде (если ничья то sideLogic)
	
*/

if ((_this select 0) <= 0) exitWith {};		// В (нулевом) раунде эта функция не нужна

private["_zonesScore","_armaScore","_curSide","_lmax"];

_zonesScore = [0,0,0];
// _armaScore = [0,0,0];
_lmax = [0,0];

{
	if (_x) then {
		_curSide = _forEachIndex;
		_zonesScore set [_curSide, 
			{
				(_x getVariable "NSA_hp_CPOwner") == ([east,west,resistance] select _curSide) 
			} count NSA_hp_CapPoints 
		];
		// _armaScore set [_curSide, scoreSide ([east,west,resistance] select _curSide) ];
	};

} forEach NSA_hp_PlayingSides;


	// Находим сторону с наибольшим количеством захваченных зон
for [{_i=0},{_i<=2},{_i=_i+1}] do {
	if ( (_zonesScore select _i) > (_lmax select 0) ) then {
		
		_lmax = [(_zonesScore select _i), _i];
	};
};


	// Проверяем, есть ли другая сторона с таким же количеством захваченных зон (потенциальный паритет по зонам) 
	// Если есть, то ничья
for [{_i=0},{_i<=2},{_i=_i+1}] do {
	if ( ((_zonesScore select _i) == (_lmax select 0)) && ((_lmax select 1) != _i) ) then {
		
		_lmax = [-1, 3]; 
	};
};

if ((_lmax select 1) < 3) then {
	NSA_hp_SidesScore set [(_lmax select 1), (NSA_hp_SidesScore select (_lmax select 1)) + 1];
};

[east,west,resistance,sideLogic] select (_lmax select 1)

