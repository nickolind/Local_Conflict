/*
null = [] call compile preprocessFileLineNumbers "init_Spectators.sqf";
NSA_hp_init_Spectators = compile preprocessFileLineNumbers "init_Spectators.sqf";
[] call NSA_hp_init_Spectators;

Для всех спектаторов - имя группы поменять на SPECTATOR (глянуть будет ли видно это имя в спектаторе)

*/

private [];
	
NSA_hp_Spectators = [];


{
	if ( (((toUpper (str _x)) find "NSA_HP_SPEC") > -1) || !(_x in playableUnits) ) then {NSA_hp_Spectators pushBack _x};
} forEach allUnits;

{
	_y = _x;
	
	if ( ({side group _x == _y} count NSA_hp_Spectators) == 0 ) then {
		_marker = "respawn_"+str(_x);
		_type = (NSA_hp_stdSpecSoldierClassnames select _forEachIndex);
		_randAng = random 360;
		_pos = [
			((getMarkerPos _marker) select 0) + ((cos _randAng) * (1 max (getMarkerSize _marker select 0) * 3 / 4)),
			((getMarkerPos _marker) select 1) + ((sin _randAng) * (1 max (getMarkerSize _marker select 1) * 3 / 4))
		];

		_type createUnit [ _pos, createGroup _x,"
			NSA_HP_SPEC_DEFAULT_"+toUpper(str _x)+" = this;
			this setDir (random 360);
			NSA_hp_Spectators pushBack this;
		"];
	};
} forEach [east,west,resistance];

{
	
	
	_x disableAI "FSM";
	_x disableAI "SUPPRESSION";
	_x disableAI "AUTOTARGET";
	_x disableAI "MOVE";
	_x disableAI "AIMINGERROR";
	_x setBehaviour "CARELESS";
	
	_x allowDamage false;

} forEach NSA_hp_Spectators;