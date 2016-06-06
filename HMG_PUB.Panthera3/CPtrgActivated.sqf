// NSA_hp_CPtrgActivated = compile preprocessFileLineNumbers "CPtrgActivated.sqf";
// [thisTrigger, thisList] spawn NSA_hp_CPtrgActivated;

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



while {triggerActivated _cp_thisTrigger} do {

	_sideOwner = [east,west,resistance,sideLogic] find (_cp_thisTrigger getVariable 'NSA_hp_CPOwner');
	_sideCap = _sideOwner;
	_sideOp = _sideOwner;
	
	_cpU = [0,0,0,0];
	for '_y' from 0 to 2 do {
		_c = 	{
					(isPlayer _x) && (vehicle _x == _x) && (side _x == ([east,west,resistance] select _y))
				} count _cp_thisList;
		_cpU set [_y, _c];
	};
	
	for '_y' from 0 to 2 do {
		if ((_cpU select _y) > (_cpU select _sideCap)) then {_sideOp = _sideOwner; _sideCap = _y;};
	};
	
	for '_y' from 0 to 2 do {
		if ( (_y != _sideCap) && ((_cpU select _y) > (_cpU select _sideOp)) ) then {_sideOp = _y;};
	};
	
	if ( (_cpU select _sideCap) == (_cpU select _sideOp) ) exitWith {};
	
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
	
	if ( ( (_CapBar select ((_sideCap + 1)%3)) + (_CapBar select ((_sideCap + 2)%3)) ) == 0 ) then {
		
		_CapBar set [_sideCap, ((_CapBar select _sideCap) + _capDelta) min 1000];
	
	} else {
		
		_CapBar set [((_sideCap + 1)%3), ((_CapBar select ((_sideCap + 1)%3)) - _capDelta) max 0];
		_CapBar set [((_sideCap + 2)%3), ((_CapBar select ((_sideCap + 2)%3)) - _capDelta) max 0];
		
		if ( ( (_CapBar select ((_sideCap + 1)%3)) + (_CapBar select ((_sideCap + 2)%3)) ) == 0 ) then {
			_cp_thisTrigger setVariable ["NSA_hp_CPOwner", sideLogic, false];
		};
		
	};
	
	_cp_thisTrigger setVariable ['NSA_hp_CapBar', _CapBar, false];
	
	
	[_cp_thisTrigger] call _UpdateCPOwner;
	
	sleep 0.5;
};


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
