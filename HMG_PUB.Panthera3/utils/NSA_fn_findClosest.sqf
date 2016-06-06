/* 
	Определяет ближайший объект из массива (2й параметр) к текущему объекту (1й параметр).
	Работает с объектами и маркерами.
	
	
	
	Вызов:
	
		_closestObj = [ _obj, [_a1,_a2,_a3], 3 ] call compile preprocessFileLineNumbers "utils\NSA_fn_findClosest.sqf";
	
	
		NSA_fn_findClosest = compile preprocessFileLineNumbers "utils\NSA_fn_findClosest.sqf";
		_closestObj = [ _obj, [_a1,_a2,_a3], 3 ] call NSA_fn_findClosest;

		
		
	Параметры:
		_obj - текущий объект или маркер
		[_a1,_a2,_a3] - массив объектов или маркеров (допустим смешанный)
		3 - если 3 (по умолч), то сравнение по трехмерное (distance), если 2, то сравнение двумерное (distance2D)

		
*/



private ["_obj","_objArray","_result","_type"];

_obj = if (typeName(_this select 0) == "STRING") then {
	[_this select 0, getMarkerPos (_this select 0)];
} else {
	[_this select 0, getPosASL (_this select 0)];
};

_objArray = _this select 1;

_type = 3;
if (count _this >= 3) then {
	if ( typeName(_this select 2) == "SCALAR") then {
		if ((_this select 2) == 2) then { _type = 2 };
	};
};

_result = if (typeName(_objArray select 0) == "STRING") then {
	[_objArray select 0, getMarkerPos (_objArray select 0)];
} else {
	[_objArray select 0, getPosASL (_objArray select 0)];
};


switch (_type) do {

	CASE 2: {
		{
			if (typeName _x == "STRING") then {
				if ( ((_obj select 1) distance2D getMarkerPos _x) < ((_obj select 1) distance2D (_result select 1)) ) then { _result = [_x, getMarkerPos _x] };
			} else {
				if ( ((_obj select 1) distance2D _x) < ((_obj select 1) distance2D (_result select 1)) ) then { _result = [_x, getPosASL _x] };
			};	
		} forEach _objArray;
	};
	
	DEFAULT {
		{
			if (typeName _x == "STRING") then {
				if ( ((_obj select 1) distance getMarkerPos _x) < ((_obj select 1) distance (_result select 1)) ) then { _result = [_x, getMarkerPos _x] };
			} else {
				if ( ((_obj select 1) distance _x) < ((_obj select 1) distance (_result select 1)) ) then { _result = [_x, getPosASL _x] };
			};	
		} forEach _objArray;
	};

};



(_result select 0)

