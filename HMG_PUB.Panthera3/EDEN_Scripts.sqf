/* 
null = ["CopyNearObjects"] execVM "EDEN_Scripts.sqf";

get3DENSelected type
(get3DENSelected "object")

*/




private ["_mode"];
_mode = _this select 0;


switch (_mode) do {

/* --------------------------------------------------------------------- // --------------------------------------------------------------------- // --------------------------------------------------------------------- //
null = ["setUnitInventory"] execVM "EDEN_Scripts.sqf";

Изменить инвентарь группы солдат на любой предварительно скопированный из Арсенала
	
	1) Подготовить копипасту из арсенала
	2) Открыть EDEN_Scripts.sqf, найти там строки:
		--------------------------------------------------------------------- 
		Копипасту из арсенала
		ЗАКИДЫВАТЬ НИЖЕ: 
		---------------------------------------------------------------------
	3) Ниже этих строк вставить копипасту из арсенала
	4) Сохранить файл EDEN_Scripts.sqf
	5) Перейти в эден, выделить группу бойцов
	6) Вызвать скрипт из консоли строкой:
		null = ["setUnitInventory"] execVM "EDEN_Scripts.sqf";


*/
	case "setUnitInventory": {
		
		#define this _this
		_invPaste = {
		/* --------------------------------------------------------------------- 
		Копипасту из арсенала
		ЗАКИДЫВАТЬ НИЖЕ: 
		--------------------------------------------------------------------- */

		
		
		/* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
		ЗАКИДЫВАТЬ ВЫШЕ 
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  */
		};
	
		{
			if (_x isKindOf "Man") then
			{
				_x call _invPaste;

				#undef this
				save3DENInventory [_x];
			};
		}
		forEach get3DENSelected "object";
	};
	

/* --------------------------------------------------------------------- // --------------------------------------------------------------------- // --------------------------------------------------------------------- //
null = ["getBoxContents"] execVM "EDEN_Scripts.sqf";

Получить содержимое ящика (в готовом виде для vehload.sqf)

	1) Выделить 1 ящик
	2) Из дебаг-консоли вызвать
		null = ["getBoxContents"] execVM "EDEN_Scripts.sqf";
	3) В буфер скопирован текст
	
*/
	case "getBoxContents": {
		
		// _curBox = _this select 1;
		_curBox = ((get3DENSelected "object") select 0);
		_boxContents = [];
		_bcString = "clearItemCargoGlobal _veh;" + toString [13] +
			"clearBackpackCargoGlobal _veh;" + toString [13] +
			"clearMagazineCargoGlobal _veh;" + toString [13] +
			"clearWeaponCargoGlobal _veh;" + toString [13];
		
		_boxContents pushBack (getWeaponCargo _curBox);
		_boxContents pushBack (getMagazineCargo _curBox);
		_boxContents pushBack (getItemCargo _curBox);
		_boxContents pushBack (getBackpackCargo _curBox);
		
		{
			if ( (_forEachIndex < 3) && (count (_x select 0) != 0) ) then {
				for [{_i=0},{_i< count (_x select 0) },{_i=_i+1}] do {
				_bcString = _bcString + 
					format ["_veh addItemCargoGlobal [""%1"", %2];", (_x select 0) select _i, (_x select 1) select _i] + toString [13];
			}; 
			};
		} forEach _boxContents;
		
		if (count (_boxContents select 3 select 0) != 0) then {
			for [{_i=0},{_i< count (_boxContents select 3 select 0) },{_i=_i+1}] do {
				_bcString = _bcString + 
					format ["_veh addBackpackCargoGlobal [""%1"", %2];", (_boxContents select 3 select 0) select _i, (_boxContents select 3 select 1) select _i] + toString [13];
			}; 
		};
		
		copyToClipboard _bcString;
	};
	

/* --------------------------------------------------------------------- // --------------------------------------------------------------------- // --------------------------------------------------------------------- //
null = ["setBoxContents"] execVM "EDEN_Scripts.sqf";

Изменить содержимое группы ящиков на подготовленное (в формате vehload.sqf)
	
	1) Подготовить копипасту из vehload.sqf
	2) Открыть EDEN_Scripts.sqf, найти там строки:
		--------------------------------------------------------------------- 
		Копипасту из vehload.sqf
		ЗАКИДЫВАТЬ НИЖЕ: 
		---------------------------------------------------------------------
	3) Ниже этих строк вставить копипасту из vehload.sqf
	4) Сохранить файл EDEN_Scripts.sqf
	5) Перейти в Эден, выделить ящик или группу ящиков
	6) Вызвать скрипт из консоли строкой:
		null = ["setBoxContents"] execVM "EDEN_Scripts.sqf";


*/
	case "setBoxContents": {
		
		_boxPaste = {
			_veh = _this;
		/* --------------------------------------------------------------------- 
		Копипасту из vehload.sqf
		ЗАКИДЫВАТЬ НИЖЕ: 
		--------------------------------------------------------------------- */


clearItemCargoGlobal _veh;
			clearBackpackCargoGlobal _veh;
			clearMagazineCargoGlobal _veh;
			clearWeaponCargoGlobal _veh;
			_veh addItemCargoGlobal ["CUP_launch_Metis", 1];
			_veh addBackpackCargoGlobal ["hmg_metis_ruck",2];
	
		
		/* ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
		ЗАКИДЫВАТЬ ВЫШЕ 
		^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  */
		};
	
		{
			if (_x isKindOf "Thing") then
			{
				boxContents = [[],false];
				
				_x call _boxPaste;

				(boxContents select 0) pushBack getWeaponCargo _x;
				(boxContents select 0) pushBack getMagazineCargo _x;
				(boxContents select 0) pushBack getItemCargo _x;
				(boxContents select 0) pushBack getBackpackCargo _x;
				
				_x set3DENAttribute ["ammoBox", str boxContents];
			};
		} forEach get3DENSelected "object";
	};
	

	
/* --------------------------------------------------------------------- // --------------------------------------------------------------------- // --------------------------------------------------------------------- //
null = ["CopyNearObjects",500] execVM "EDEN_Scripts.sqf";

Скопировать группу построек из любой карты, чтобы ими можно было манипулировать в Эдене
	(скопируются в основном здания)

1) В Эдене - навести центр экрана на интересующую группу зданий на карте
2) Вызвать из консоли (второй параметр - радиус охвата):
	null = ["CopyNearObjects",500] execVM "EDEN_Scripts.sqf";

*/
	case "CopyNearObjects": {
		
		_range = _this select 1;
		
		// ScannedObjectsList = nearestTerrainObjects [(screenToWorld [0.5,0.5]), [], _range];
		// ScannedObjectsList = nearestObjects [(screenToWorld [0.5,0.5]), [], _range];
		ScannedObjectsList = (screenToWorld [0.5,0.5]) nearObjects ["all",_range]; 
		objList = [];
		{   
			curType = typeOf _x;
			
			tVeh = create3DENEntity ["Object", curType, 
				position _x
			];
			
			tVeh setPosWorld getPosWorld _x;
			tVeh setVectorDirAndUp [vectorDir _x, vectorUp _x];
			
			tVeh set3DENAttribute ["rotation", [0,0,direction _x]];
			tVeh set3DENAttribute ["position",[
				(getPosWorld _x select 0),
				(getPosWorld _x select 1),
				(position _x select 2)
			]
			];
			
			// tVeh setPosWorld getPosWorld _x;
			// tVeh setVectorDirAndUp [vectorDir _x, vectorUp _x];
			
		} forEach ScannedObjectsList;
	
	};
	

	
/* --------------------------------------------------------------------- // --------------------------------------------------------------------- // --------------------------------------------------------------------- //
null = ["setRandomName"] execVM "EDEN_Scripts.sqf";

Выбранной группе юнитов присваивает рандомное имя (из списков имен и фамилий, подготовленных заранее)

	1) Подготовить список имен и фамилий (воткнуть их в скрипт)
	2) Выбрать группу юнитов в Эдене
	3) Вызвать скрипт

*/
	case "setRandomName": {
		
		// Имена
		_name1 = [	
			"Christian",
			"Jonas",
			"Michael",
			"Martin",
			"Sebastian",
			"Alex",
			"Patrick",
			"Mark",
			"Rene",
			"Robby",
			"Tim",
			"Theo",
			"Viktor",
			"Wilmut",
			"York"
		];
		
		// Фамилии
		_name2 = [
			"Müller",
			"Schmidt",
			"Schneider",
			"Fischer",
			"Schulz",
			"Bauer",
			"Hofmann",
			"Schulze",
			"Vogel",
			"Kraus"
		];
		
		{
			if (_x isKindOf "Man") then
			{
				_x set3DENAttribute ["unitName", format ["%1 %2", _name1 select ( floor(random(count _name1)) ), _name2 select ( floor(random(count _name2)) )]  ];
			};
		} forEach get3DENSelected "object";
	
	};
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
/* --------------------------------------------------------------------- 
null = ["spawnAllMapObjects"] execVM "EDEN_Scripts.sqf";



(nearestObjects [screenToWorld [0.5,0.5], [], 10])
typeof (nearestObjects [screenToWorld [0.5,0.5], [], 10] select 0)



{
	ScannedObjectsList = nearestTerrainObjects [player, [], 20000]; 

	Possible type names:"TREE", "SMALL TREE", "BUSH", "BUILDING", "HOUSE", "FOREST BORDER", "FOREST TRIANGLE", "FOREST SQUARE", "CHURCH", "CHAPEL", "CROSS", "ROCK", "BUNKER", "FORTRESS", "FOUNTAIN", "VIEW-TOWER", "LIGHTHOUSE", "QUAY", "FUELSTATION", "HOSPITAL", "FENCE", "WALL", "HIDE", "BUSSTOP", "ROAD", "FOREST", "TRANSMITTER", "STACK", "RUIN", "TOURISM", "WATERTOWER", "TRACK", "MAIN ROAD", "ROCKS", "POWER LINES", "RAILWAY", "POWERSOLAR", "POWERWAVE", "POWERWIND", "SHIPWRECK", "TRAIL"
}


ScannedObjectsList = position player nearObjects ["all",20000]; 

nearestObjects [player, [], 5];
	Отображаются вообще любые объекты (может не быть типа по typeOf). Может пригодиться для разрушения чего-л:
		(nearestObjects [player, [], 5] select 1) setDamage 1

nearestObjects [player, ["all"], 5];
	Отображаются все объекты, у которых можно узнать их тип (typeOf)
		curObj = nearestObjects [player, ["house"], 5];
		tVeh = create3DENEntity ["Object", typeOf curObj, position player];
		
*/
	case "spawnAllMapObjects": {
	
		curPos = [-100,0,0];

		ScannedObjectsList = nearestTerrainObjects [screenToWorld [0.5,0.5], [], 30000]; 
		// ScannedObjectsList = (screenToWorld [0.5,0.5]) nearObjects ["all",20000]; 
		objList = [];
		{   
			curType = typeOf _x;
			if !(curType in objList) then {    
				objList pushBack curType;
			};  
		} forEach ScannedObjectsList;
		objList sort true;

		{
			if (curPos select 1 < -250) then {
				curPos set [0, (curPos select 0) - 30];
				curPos set [1, 0];
			} else {
				curPos set [1, (curPos select 1) - 25];
			};   
			tVeh = create3DENEntity ["Object", _x, curPos];
		} forEach objList;
		
		copyToClipboard str objList;
		systemChat format ["Обнаружено объектов: %1", count objList];
	
	};
	
	
/* --------------------------------------------------------------------- 
null = ["collectAllObjects"] execVM "EDEN_Scripts.sqf";
*/
	case "collectAllObjects": {
		
		AllFoundObjs = [];
		
		ScannedObjectsList = nearestTerrainObjects [screenToWorld [0.5,0.5], [], 30000]; 
		// ScannedObjectsList = (screenToWorld [0.5,0.5]) nearObjects ["all",20000]; 
		objList = [];
		{   
			curType = typeOf _x;
			if !( (curType in objList) || (curType in AllFoundObjs) ) then {    
				objList pushBack curType;
				AllFoundObjs pushBack curType;
			};  
		} forEach ScannedObjectsList;
		objList sort true;
		AllFoundObjs sort true;
		
		curPos = [1000,0,0];
		{
			if (curPos select 1 < -250) then {
				curPos set [0, (curPos select 0) - 30];
				curPos set [1, 0];
			} else {
				curPos set [1, (curPos select 1) - 25];
			};   
			tVeh = create3DENEntity ["Object", _x, curPos];
		} forEach objList;
		
		// copyToClipboard str objList;
		copyToClipboard str AllFoundObjs;
		systemChat format ["Обнаружено новых объектов: %1", count objList];
		systemChat format ["Всего в базе: %1", count AllFoundObjs];
	
	};	
	
	
/* --------------------------------------------------------------------- 
null = ["spawn_AllFoundObjs"] execVM "EDEN_Scripts.sqf";
*/
	case "spawn_AllFoundObjs": {
		
		xPos = -100;
		yPos = 0;
		curPos = [xPos,yPos,0];

		{
			
			// if (curPos select 0 < (xPos-1000) ) then {
				// curPos set [0, (curPos select 0) - 30];
				// curPos set [1, 0];
			// }
			
			if (curPos select 1 < (yPos-500) ) then {
				curPos set [0, (curPos select 0) - 30];
				curPos set [1, 0];
			} else {
				curPos set [1, (curPos select 1) - 25];
			};   
			tVeh = create3DENEntity ["Object", _x, curPos];
		} forEach AllFoundObjs;
	
	};
	
	
	
	
/* --------------------------------------------------------------------- 
null = ["test"] execVM "EDEN_Scripts.sqf";
*/
	case "test": {
	
	

	
	
	
	};

/* --------------------------------------------------------------------- */	
};



