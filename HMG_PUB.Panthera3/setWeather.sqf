/*
null = [_newTime, _newWeather] call compile preprocessFileLineNumbers "setWeather.sqf";
NSA_hp_setWeather = compile preprocessFileLineNumbers "setWeather.sqf";
[_newTime, _newWeather] call NSA_hp_setWeather;


	Функция для клиентов и сервера. Обновляет погоду
*/

private ["_newTime","_newWeather"];

_newTime = _this select 0;
_newWeather = _this select 1;	// [overcast, rain, lightning, fog]

60 setOvercast (random (_newWeather select 0)); // 86400 = 24hrs
if (isServer) then { 
	60 setRain (_newWeather select 1); 
	60 setFog (_newWeather select 3);
};
60 setLightnings (_newWeather select 2);

// forceWeatherChange;
skipTime 24;
setDate _newTime;