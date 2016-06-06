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
	
	// NSA_hp_RoundsCount = 0;
};

NSA_Timer = compile preprocessFileLineNumbers "NSA_Timer.sqf";

NSA_hp_Base_AllowDamage = compile preprocessFileLineNumbers "Base_AllowDamage.sqf";
NSA_hp_init_mission = compile preprocessFileLineNumbers "init_mission.sqf";
NSA_hp_init_newRound = compile preprocessFileLineNumbers "init_newRound.sqf";
NSA_hp_init_respawnWave = compile preprocessFileLineNumbers "init_respawnWave.sqf";
NSA_hp_init_Spectators = compile preprocessFileLineNumbers "init_Spectators.sqf";
NSA_hp_main_loop = compile preprocessFileLineNumbers "main_loop.sqf";
NSA_hp_publicVarsBroadcast = compile preprocessFileLineNumbers "publicVarsBroadcast.sqf";


// NSA_hp_GameState = 1;

// ---------------------------------------- Init block ---------------------------------------- //


if (isServer) then {
	[] spawn NSA_hp_publicVarsBroadcast;
};

if !(isDedicated) then {
	
};

null = [] spawn NSA_hp_init_mission;