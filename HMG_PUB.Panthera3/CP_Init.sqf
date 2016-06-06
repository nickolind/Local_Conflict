/* [] call compile preprocessFileLineNumbers "CP_Init.sqf";
NSA_hp_CP_Init = compile preprocessFileLineNumbers "CP_Init.sqf";
[] call NSA_hp_CP_Init;



*/

if !(isServer) exitWith {};

private ["_mName","_newMarker","_mrkVars","_connectedCPs","_chosenCP","_rand","_trg","_nextCP","_allCPs","_PointsArray","_z","_findMarkerOwner","_firstCP","_conCPs","_curMarker","_otherMarker"];

//---------------------------- Очистка от прошлого раунда ---------------------------

if (!isNil{NSA_hp_CapPoints}) then {
	while {count NSA_hp_CapPoints > 0} do {
		_j = NSA_hp_CapPoints select (count NSA_hp_CapPoints -1);
		deleteMarker (_j getVariable "NSA_hp_CPMarker");
		deleteVehicle _j;
		NSA_hp_CapPoints deleteAt (count NSA_hp_CapPoints -1);
	};
};

if (!isNil{NSA_hp_CP_lineMarkers}) then {
	{
		deleteMarker _x;
	} forEach NSA_hp_CP_lineMarkers;
};

//---------------------------- Очистка от прошлого раунда ---------------------------




//---------------------------- Инициализация точек в начале раунда ---------------------------	
_allCPs = [];
_connectedCPs = [];
NSA_hp_CapPoints = [];
NSA_hp_clientCapPoints = [];
NSA_hp_CP_lineMarkers = [];


for [{_i=0},{_i<=100},{_i=_i+1}] do {
	_mName = ("pa_" + str(_i));
	if ( getMarkerColor _mName != "" ) then {			
		_allCPs pushBack _mName;
	};
};
_PointsArray = +_allCPs;

for [{_i=1},{_i<=NSA_hp_CPnum},{_i=_i+1}] do {
	
	_nextCP = [];
	{
		
		if ( ((_x in _connectedCPs) ) || (_i == 1) ) then {
			
#ifdef USE_P_DIST	// --- Ограничение выбора точек в зависимости от дистанции между ними (не выбирать точки, расположенные слишком близко друг к другу)	
			_z = _x;
			if ( ( {(_z distance _x) < NSA_hp_distBP} count NSA_hp_CapPoints) == 0 ) then {
#endif
			
				_nextCP pushBack _x;

#ifdef USE_P_DIST	
			};
#endif
		};
	} forEach _PointsArray;
	
	_rand = (floor (random(count _nextCP)));
	_chosenCP = _nextCP select _rand;
	_PointsArray deleteAt (_PointsArray find _chosenCP);
	
	_mrkVars = call compile(markerText _chosenCP);		/*marker vars:		['Name', [100,100], ['pa_1', 'pa_4']]
															(_mrkVars select 0) -- Text
															(_mrkVars select 1) -- Size
															(_mrkVars select 2) -- connected CapturePoints
														*/
	_trg = createTrigger ["EmptyDetector", getMarkerPos _chosenCP, false];
	_trg setTriggerArea [(_mrkVars select 1) select 0, (_mrkVars select 1) select 1, 0, false];
	_trg setTriggerActivation ["ANY", "PRESENT", true];
	_trg setTriggerText ("trgZone_"+_chosenCP);
	NSA_hp_CapPoints pushBack _trg;
	_connectedCPs = _connectedCPs + (_mrkVars select 2);
	
	_mName = createMarker ["mZone_" + _chosenCP, getMarkerPos _chosenCP];
	_mName setMarkerShape "ELLIPSE";
	_mName setMarkerSize (_mrkVars select 1);
	_mName setMarkerColor "ColorBlack";
	_mName setMarkerBrush "SolidBorder";
	_trg setVariable ["NSA_hp_CPMarker", _mName, false];
	
	_trg setVariable ["NSA_hp_CapBar", [0,0,0,0], false];		// [east,west,resistance,sideLogic]
	// _trg setVariable ["NSA_hp_CapBar", [0,1000,0,0], false];		// testing
	_trg setVariable ["NSA_hp_CPOwner", sideLogic, false];
	// _trg setVariable ["NSA_hp_CPOwner", west, false];			// testing
	_trg setVariable ["NSA_hp_connectedCPs", (_mrkVars select 2), false];	// Содержит всех возможных соседей (формат маркеров). Ниже этот массив заменяется на массив триггеров точек захвата и содержит только активные ТЗ
	
	NSA_hp_clientCapPoints pushBack [_mName, _trg getVariable "NSA_hp_CapBar", _trg getVariable "NSA_hp_CPOwner"];		// Список точек (маркеров) для клиентов
	
	trgt = _trg; // testing
	
	_trg setTriggerStatements [
		"
			this && ([thisTrigger, thisList] call NSA_hp_CPtrgCondition)
		", 
		"
			null = [thisTrigger, thisList] spawn NSA_hp_CPtrgActivated;
		", 
		"
		
		"
	];
};

publicVariable "NSA_hp_clientCapPoints";

//---------------------------- Инициализация точек в начале раунда ---------------------------	



//---------------------------- Создание связей между точками ---------------------------	
_findMarkerOwner = {
	private["_result"];
	_result = objNull;
	
	{
		if ( (_x getVariable "NSA_hp_CPMarker") == (_this select 0) ) exitWith {_result = _x};
	} forEach NSA_hp_CapPoints;
	
	_result
};

_drawLineMarker = {
	private ["_curMarker","_otherMarker","_lineMarker","_lmPos","_lmDir","_vd"];	
	
	_curMarker = _this select 0;
	_otherMarker = _this select 1;
	
	_lmPos = [
		((getMarkerPos _curMarker select 0) + (getMarkerPos _otherMarker select 0)) / 2 ,
		((getMarkerPos _curMarker select 1) + (getMarkerPos _otherMarker select 1)) / 2
	];

		// Get direction from _obj1 to _obj2:
	_vd = getMarkerPos _otherMarker vectorDiff getMarkerPos _curMarker;
	_lmDir = (_vd select 0) atan2 (_vd select 1); //_dir range from -180 to +180 
	if (_lmDir < 0) then {_lmDir = 360 + _lmDir}; //_dir range from 0 to 360
	
	_lineMarker = createMarker [(_curMarker + "_to_" + _otherMarker), _lmPos];
	_lineMarker setMarkerShape "RECTANGLE";
	_lineMarker setMarkerSize [4, (((getMarkerPos _otherMarker) distance2D (getMarkerPos _curMarker)) / 2)];
	_lineMarker setMarkerColor "ColorBlack";
	_lineMarker setMarkerBrush "Solid";
	_lineMarker setMarkerDir _lmDir;
	
	NSA_hp_CP_lineMarkers pushBack _lineMarker;
};

_findFirstCP = {

	private ["_result","_pickSide","_z","_candidates","_rand","_randSide"];
	
	_result = [objNull,objNull,objNull];
	_candidates = [];
	
	{
		if ( (count (_x getVariable "NSA_hp_connectedCPs") == 1) ) then {
			_candidates pushBack _x;
		};
	} forEach NSA_hp_CapPoints;
	
	// diag_log format ["_candidates=%1",_candidates];	// testing
	if (count _candidates >= 2) then {	// Выбрать ближайшую к базе конечную точку
		_pickSide = [east,west,resistance];
		
		while {count _pickSide > 0} do {
			_rand = (floor (random(count _pickSide)));
			_randSide = [east,west,resistance] find (_pickSide select _rand);		// Начинаем со случайной стороны, а не всегда с EAST
			
			if ( NSA_hp_PlayingSides select _randSide ) then {
				
				_result set [_randSide, ([ (NSA_hp_BaseTriggers select _randSide), _candidates, 2] call NSA_fn_findClosest)];
				
			};	
			_pickSide deleteAt _rand;
		};
	
	} else {	// Выбрать ближайшую к базе точку
		_candidates = +NSA_hp_CapPoints;
		_pickSide = [east,west,resistance];
		
		while {count _pickSide > 0} do {
			_rand = (floor (random(count _pickSide)));
			_randSide = [east,west,resistance] find (_pickSide select _rand);		// Начинаем со случайной стороны, а не всегда с EAST
			
			if ( NSA_hp_PlayingSides select _randSide ) then {
				
				_result set [_randSide, ([ (NSA_hp_BaseTriggers select _randSide), _candidates, 2] call NSA_fn_findClosest)];
				_z = _candidates find (_result select (count _result - 1 ));
				_candidates deleteAt (_z);		// Удалить уже использованную точку, чтобы у нескольких сторон не было одинаковой начальной точки
			};	
			_pickSide deleteAt _rand;
		};
	
	};
	

	_result			// формат: [sCP1, sCP2, sCP3]

};



diag_log format ["testCRASH - CP_Init: 1"];	// testing

{

	_conCPs = [];
	_curMarker = (_x getVariable "NSA_hp_CPMarker");
	
	{
		_otherMarker = ("mZone_" + _x);
		if ( getMarkerColor _otherMarker != "" ) then {			
			
			_conCPs pushBack ( [_otherMarker] call _findMarkerOwner );
			
			
			
				// -- Создать маркер-линию между двумя связанными точками
			if ( 
				(getMarkerColor (_curMarker + "_to_" + _otherMarker) == "")
				&& 
				(getMarkerColor (_otherMarker + "_to_" + _curMarker) == "")
			) then {
				[_curMarker, _otherMarker] call _drawLineMarker;
			};
			
			
		};
	} forEach (_x getVariable "NSA_hp_connectedCPs");
	
	_x setVariable ["NSA_hp_connectedCPs", _conCPs, false];
	
} forEach NSA_hp_CapPoints;



// Нахождение крайних точек и связывание их с базами сторон
_firstCP = [] call _findFirstCP;

{
	// Если точка - первая точка от базы стороны - связать ее с точкой базы
	if !(isNull _x) then {	
		_curMarker = (_x getVariable "NSA_hp_CPMarker");
		_conCPs = _x getVariable "NSA_hp_connectedCPs";
		_conCPs pushBack ( NSA_hp_BaseTriggers select _forEachIndex);
		_x setVariable ["NSA_hp_connectedCPs", _conCPs, false];
		
		_otherMarker = createMarker ["tempCPM", position (NSA_hp_BaseTriggers select _forEachIndex)]; 
		[_curMarker, _otherMarker] call _drawLineMarker;
		deleteMarker _otherMarker;		
	};		
} forEach _firstCP;

//---------------------------- Создание связей между точками ---------------------------

diag_log format ["testCRASH - CP_Init: 2"];	// testing




/*---------------------------- Восстановление разрушенных зданий ---------------------------
	В массив заносятся списки зданий внутри потенциальных точек захвата.
	Между раундами если здания на новых ТЗ разрушены - они восстанавливаются,
	чтобы через Х минут карта не превратилась в пустырь.
*/

// Первичное составление списков зданий
if (count NSA_hp_CPBuildings <= 0) then {
	private "_nObjs";
	
	{
		_mrkVars = call compile(markerText _x);		/*marker vars:		['Name', [100,100], ['pa_1', 'pa_4']]
															(_mrkVars select 0) -- Text
															(_mrkVars select 1) -- Size
															(_mrkVars select 2) -- connected CapturePoints
														*/
			
		_nObjs = nearestTerrainObjects [getMarkerPos _x, ["building","house"], ((_mrkVars select 1) select 0) + 20];
		
		NSA_hp_CPBuildings pushBack [_x, _nObjs];		// format: ["pa_0", [houseObj1, houseObj2, houseObj3]]	
	} forEach _allCPs;
};

diag_log format ["testCRASH - CP_Init: 3"];	// testing

// Проверка перед началом каждого нового раунда - если есть ли разрушенные здания, то восстановить
{
	_z = _x;	
	{
		if (_z getVariable ["NSA_hp_CPMarker", ""] == ("mZone_"+(_x select 0)) ) exitWith {
			
			{
				if (damage _x > 0.9) then { _x setDamage (random 0.5) };
			} forEach (_x select 1);	
		};
	} forEach NSA_hp_CPBuildings;
} forEach NSA_hp_CapPoints;

diag_log format ["testCRASH - CP_Init: 4"];	// testing
//---------------------------- Восстановление разрушенных зданий ---------------------------


	
