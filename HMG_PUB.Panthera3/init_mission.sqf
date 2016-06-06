// null = [] spawn compile preprocessFileLineNumbers "init_mission.sqf";
// NSA_hp_init_mission = compile preprocessFileLineNumbers "init_mission.sqf";
// [] spawn NSA_hp_init_mission;


// #define USE_P_DIST 1		// --- Ограничение выбора точек в зависимости от дистанции между ними (не выбирать точки, расположенные слишком близко друг к другу)


	// --------------- Параметры миссии (настраиваемые) --------------- //
													
													
													
NSA_param_gamePrepareTime 		= 20;		// NSA_param_gamePrepareTime -->  		120
NSA_param_roundTime 			= 20;		// NSA_param_roundTime -->  			2400	(40mins)
NSA_param_respawnWave 			= 15;		// NSA_param_respawnWave -->  			600		(10mins)

NSA_hp_CPnum 					= 3;		// Количество точек для удержания
NSA_hp_distBP 					= 400;		// Дистанция между точками, чтобы они могли быть выбраны
NSA_hp_stdSpecSoldierClassnames	= ["rhs_msv_officer_armored","rhsusf_usmc_marpat_wd_squadleader","I_G_Soldier_SL_F"];

	// --------------- Параметры миссии (настраиваемые) --------------- //
	
	
	
	
NSA_hp_RoundsCount = 0;
NSA_hp_GameState = 1;
NSA_hp_roundTime = 0;
NSA_hp_SidesScore = [0,0,0];



if (isServer) then {


	NSA_hp_BaseTriggers = [];		// format: [trgKT_EAST_Inn, trgKT_WEST_Inn, objNull]
	NSA_hp_CPBuildings = [];		// format: ["pa_0", [houseObj1, houseObj2, houseObj3]] -- Списки зданий внутри потенциальных точек захвата
	// NSA_hp_dawn_dusk = [[6,52],[15,19]];	// format: [dawnTime, duskTime ] -- явное указание значений восхода и заката для миссии. Иначе будет вычисляться автоматически (точность хромает).
		// ^ Задавать в Эдене через GameLogicVars
	NSA_hp_PlayingSides = [false,false,false];	// [east,west,resistance]
	
	
	
	
	{
		if ( (playableSlotsNumber _x) > 0 ) then { 
			NSA_hp_PlayingSides set [_forEachIndex, true];
			
			_BaseTriggers = call compile (["trgKT_EAST_Inn", "trgKT_WEST_Inn", "trgKT_RESISTANCE_Inn"] select _forEachIndex);
			if !( isNil{_BaseTriggers}) then {
				NSA_hp_BaseTriggers pushBack _BaseTriggers;
				_BaseTriggers setVariable ["NSA_hp_CPOwner", _x, false];
			} else {
				["CRITICAL ERROR: Side base trigger not specified (init_mission.sqf::NSA_hp_BaseTriggers)"] call NSA_hp_errorCatcher;
			};
			
		} else {
			NSA_hp_BaseTriggers pushBack (objNull);
		};
	} forEach [east,west,resistance];
	publicVariable "NSA_hp_BaseTriggers";

	

	[] call NSA_hp_init_Spectators;
	
	[] spawn NSA_hp_publicVarsBroadcast;


	[NSA_param_gamePrepareTime, NSA_param_roundTime, NSA_param_respawnWave] spawn NSA_hp_main_loop;
	
};



if !(isDedicated) then {
	waitUntil {sleep 0.102; player == player };
	
	
	player setVariable ["NSA_plrSide", side group player];	
		// player setVariable ["NSA_plrSide", side group player, true];
	
	waitUntil { sleep 0.27; !(isNil{NSA_hp_RespawnWave}) };
	
	[] spawn NSA_hp_c_getCPstatus;
	
	player setVariable ["NSA_plrInitDone", true];
};

[] spawn NSA_hp_Base_AllowDamage_AllOther;