// [] call compile preprocessFileLineNumbers "CP_Init.sqf";
// NSA_hp_CP_Init = compile preprocessFileLineNumbers "CP_Init.sqf";
// [] call NSA_hp_CP_Init;


if !(isServer) exitWith {};

private ["_mName","_mName","_mrkVars","_connectedCPs","_chosenCP","_rand","_trg","_CPnum","_nextCP","_PointsArray"];

//---------------------------- Очистка от прошлого раунда ---------------------------

if (!isNil{NSA_hp_CapPoints}) then {
	while {count NSA_hp_CapPoints > 0} do {
		_j = NSA_hp_CapPoints select (count NSA_hp_CapPoints -1);
		deleteMarker (_j getVariable "NSA_hp_CPMarker");
		deleteVehicle _j;
		NSA_hp_CapPoints deleteAt (count NSA_hp_CapPoints -1);
	};
};

//---------------------------- Очистка от прошлого раунда ---------------------------




//---------------------------- Инициализация точек в начале раунда ---------------------------	
_PointsArray = [];
_connectedCPs = [];
NSA_hp_CapPoints = [];
_CPnum = 3;		// Количество точек для удержания

for [{_i=0},{_i<=100},{_i=_i+1}] do {
	_mName = ("pa_" + str(_i));
	if ( getMarkerColor _mName != "" ) then {			
		_PointsArray pushBack _mName;
	};
};

for [{_i=1},{_i<=_CPnum},{_i=_i+1}] do {
	
	_nextCP = [];
	{
		if ( (_x in _connectedCPs) || (_i == 1) ) then {
			_nextCP pushBack _x;
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
	
	// _trg setVariable ["NSA_hp_CapBar", [0,0,0,0], false];		// [east,west,resistance,sideLogic]
	_trg setVariable ["NSA_hp_CapBar", [0,1000,0,0], false];		// testing
	// _trg setVariable ["NSA_hp_CPOwner", sideLogic, false];
	_trg setVariable ["NSA_hp_CPOwner", west, false];			// testing
	
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
//---------------------------- Инициализация точек в начале раунда ---------------------------	
