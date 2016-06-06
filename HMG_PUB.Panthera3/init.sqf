enableSaving [false, false];
enableSentences false;

setterraingrid 6.25;

// ---------------------------------------- Dependencies ---------------------------------------- //
tf_west_radio_code = "12345";
tf_east_radio_code = "12345";
tf_guer_radio_code = "12345";

wmt_hl_disable = true;
ace_interaction_EnableTeamManagement = false;

// cTab_vehicleClass_has_FBCB2 = [];
// cTab_vehicleClass_has_TAD = [];

// ---------------------------------------- Dependencies ---------------------------------------- //




// ---------------------------------------- Init block ---------------------------------------- //
if (isServer) then {
	NSA_hp_CP_Init = compile preprocessFileLineNumbers "CP_Init.sqf";
	NSA_hp_CPtrgCondition = compile preprocessFileLineNumbers "CPtrgCondition.sqf";
	NSA_hp_CPtrgActivated = compile preprocessFileLineNumbers "CPtrgActivated.sqf";
	
	NSA_fnc_sun = compile preprocessFileLineNumbers "utils\fn_sun.sqf"; // Server
	
	// NSA_hp_RoundsCount = 0;
};

NSA_Timer = compile preprocessFileLineNumbers "utils\NSA_fn_Timer.sqf";
NSA_fn_findClosest = compile preprocessFileLineNumbers "utils\NSA_fn_findClosest.sqf";

NSA_hp_Base_AllowDamage_Player = compile preprocessFileLineNumbers "Base_AllowDamage_Player.sqf";
NSA_hp_Base_AllowDamage_AllOther = compile preprocessFileLineNumbers "Base_AllowDamage_AllOther.sqf";
NSA_hp_c_getCPstatus = compile preprocessFileLineNumbers "c_getCPstatus.sqf";
NSA_hp_errorCatcher = compile preprocessFileLineNumbers "errorCatcher.sqf";
NSA_hp_init_mission = compile preprocessFileLineNumbers "init_mission.sqf";
NSA_hp_init_newRound = compile preprocessFileLineNumbers "init_newRound.sqf";
NSA_hp_init_respawnWave = compile preprocessFileLineNumbers "init_respawnWave.sqf";
NSA_hp_init_Spectators = compile preprocessFileLineNumbers "init_Spectators.sqf";
NSA_hp_main_loop = compile preprocessFileLineNumbers "main_loop.sqf";
NSA_hp_publicVarsBroadcast = compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";
NSA_hp_setSidesScore = compile preprocessFileLineNumbers "setSidesScore.sqf";
NSA_hp_setWeather = compile preprocessFileLineNumbers "setWeather.sqf";	//All


// NSA_hp_GameState = 1;

// ---------------------------------------- Init block ---------------------------------------- //


if (isServer) then {
	
};

if !(isDedicated) then {
	
};

null = [] spawn NSA_hp_init_mission;