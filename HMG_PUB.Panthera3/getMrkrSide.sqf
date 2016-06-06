// _mrkrSide = [_markerName] call compileFinal preprocessFileLineNumbers "getMrkrSide.sqf";
// _mrkrSide = [_markerName] call compile preprocessFileLineNumbers "getMrkrSide.sqf";

private ["_result","_mrkrName"];
	
_mrkrName = toUpper(_this select 0);
_result = sideLogic;

switch (true) do {
	
	CASE ((_mrkrName find "WEST") != -1 ) : {
		_result = west;
	};
	
	CASE ((_mrkrName find "EAST") != -1 ) : {
		_result = east;
	};
	
	CASE ( 
		((_mrkrName find "RESISTANCE") != -1 ) 
		|| 
		((_mrkrName find "GUER") != -1 ) 
		|| 
		((_mrkrName find "INDEPENDENT") != -1 )  
	
	) : {
		_result = resistance;
	};
};

_result

