/*
null = [] call compile preprocessFileLineNumbers "test.sqf";

*/


	
	test_result = [];
	test_result2 = [];
	_candidates = [];
	
		_candidates = +NSA_hp_CapPoints;
		_pickSide = +NSA_hp_PlayingSides;
		
		while {count _pickSide > 0} do {
			_rand = (floor (random(count _pickSide)));		// �������� �� ��������� �������, � �� ������ � EAST
			test_result pushBack _rand;
			if ( _pickSide select _rand ) then {
				test_result2 pushBack _rand;
				// _result pushBack ([ (NSA_hp_BaseTriggers select _rand), _candidates, 2] call NSA_fn_findClosest);
				// _z = _candidates find (_result select (count _result - 1 ));
				// _candidates deleteAt (_z);		// ������� ��� �������������� �����, ����� � ���������� ������ �� ���� ���������� ��������� �����
				
			};
			_pickSide deleteAt _rand;			
		};
	
	
	// test_result = +_result;