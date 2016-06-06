/*
NSA_hp_errorCatcher = compile preprocessFileLineNumbers "errorCatcher.sqf";
[_message] call NSA_hp_errorCatcher;

	(_this select 0) <-- _message
*/

if !(isServer) exitWith { 
	diag_log (_this select 0);
	hint (_this select 0); 
	
	[[ [ format ["Client Error ('%1', %2) -- %3", name player, player, (_this select 0)] ], {		
		diag_log (_this select 0);
	}],"BIS_fnc_call", false] call BIS_fnc_MP;  
};

[[ [(_this select 0)], {		
	diag_log (_this select 0);
	hint (_this select 0); 	 		
}],"BIS_fnc_call"] call BIS_fnc_MP; 

