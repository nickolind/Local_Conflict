// [_tName, _cveh, _tHight]

//Выполняется на клиентской машине
private ["_i","_tName","_cvek","_victim","_tHight","_time","_ns_mark","_mrk_text"];

_tName = _this select 0;
_cvek = _this select 1;
_victim = _this select 2;
_tHight = _this select 3;

waitUntil {sleep 0.5; _victim getVariable "NSA_KTO_Sent" == -1};

_victim setVariable ["NSA_KTO_Sent", 1, true];

_i = 0;
_mrk_text = format ["%1:%2", 
				side group _victim, 
				getText (configFile >> "CfgVehicles" >> (typeof vehicle _victim) >> "displayName")
			];
_ns_mark = if ( getMarkerColor ("NSA_KTO_" + (name _victim)) == "" ) then {
	createMarker ["NSA_KTO_" + (name _victim), position _victim ];
} else { 
	("NSA_KTO_" + (name _victim));
};

_ns_mark setMarkerSize [0.7, 0.7];
_ns_mark setMarkerType "mil_warning";
_ns_mark setMarkerColor "ColorCIV";

{
	if ( (isPlayer _x) && (side group _x != side group _victim) ) then {
	// if ( (isPlayer _x) ) then {
		[[[], {
			["<t color='#FFA500' size = '.6'>Пересечение зоны КТ (карта обновлена)</t>",0,0.9,5,0.7,0,789] call bis_fnc_dynamictext;
		}],"BIS_fnc_call", _x] call BIS_fnc_MP;
	};
} forEach playableUnits;

waitUntil {

	_ns_mark setMarkerPos (position _victim);
	_ns_mark setMarkerText ( format ["%1(%2)", _mrk_text, ([daytime, "HH:MM:SS"] call BIS_fnc_timeToString)] );
	
	sleep 20;
	
	if (
		( !(_victim in list _tName) && !((_cvek in list _tName) && (_victim in crew _cvek)) )
		|| 
		( !((getPosATL _victim select 2) <= _tHight) && !(((getPosATL _cvek select 2) <= _tHight) && (_victim in crew _cvek)) )
		||
		!( alive _victim )
	
	) exitWith { 
		// _ns_mark setMarkerText ( format ["%1(%2)", _mrk_text, ([daytime, "HH:MM:SS"] call BIS_fnc_timeToString)] );
		true
	};
};
// _ns_mark setMarkerPos (position _victim);
_time = serverTime;
	
	
[_victim, _time, _ns_mark] spawn {
	private ["_l_mrk","_obs_mark"];
	_l_mrk = _this select 2;
	
	waitUntil {
		sleep 5;
		
		if !( alive (_this select 0) ) then {
			_obs_mark = createMarker [_l_mrk + "_OBS_" + str(round time), getMarkerPos _l_mrk ];
			_obs_mark setMarkerSize (getMarkerSize _l_mrk);
			_obs_mark setMarkerType (getMarkerType _l_mrk);
			_obs_mark setMarkerColor (getMarkerColor _l_mrk);
			_obs_mark setMarkerText (markerText _l_mrk);
			deleteMarker _l_mrk;
			_l_mrk = _obs_mark;
		};
		if ( ((_this select 0) getVariable ["NSA_KTO_Sent",0] != 0) && (alive (_this select 0)) ) exitWith { true };
		if ((serverTime - (_this select 1)) >= 180)  exitWith {deleteMarker _l_mrk; true};
			
	};
};


_victim setVariable ["NSA_KTO_Sent", 0, true];

