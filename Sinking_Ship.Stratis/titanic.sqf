/**
*   by IR0NSIGHT
* 	sinking ship script
*	place file in mission folder 
*	put "[this,1,true] execVM "titanic.sqf;" into ships init box in editor
*	@params:
*	@ship: object to sink
*	@direction: direction for the ship to move in in [north, east, up] format, meters per second.
*	@pitchBank: [pitch, bank] per second
	@timeout: time in seconds until stopping.
*   @out: nothing

	[ship_01,[10,0,-2],[-1,0],10] execVM "titanic.sqf";
**/
_updateShipParts = {
	params ["_ship"];
	private _PitchBank =  _ship call bis_fnc_getPitchBank;
	_PitchBank params [["_Pitch",0],["_Bank",0]];
	_t_objs=_ship getvariable ["TypeObjs",[]];
	_objs = _ship getvariable ["ShipObjs",[]];
	_shiploc = _ship getvariable ["ShipLocObj",objNull];

	{
		_loc = _x getVariable ["ShipsLoc",""];

		_x setPosworld (_shiploc modelToWorldWorld (_shiploc selectionPosition _loc));
		_x setdir (getDir _ship);
		[_x, _Pitch, _Bank] call bis_fnc_setPitchBank;
	}foreach _t_objs;

	{
		_loc = _x getVariable ["ShipsLoc",""];
		_x setPos(_shiploc modeltoworld (_shiploc selectionPosition _loc));
		_x setdir (getDir _ship);
		[_x, _Pitch, _Bank] call bis_fnc_setPitchBank;
	}foreach _objs;
};

params ["_ship","_dir","_pitchBank","_timeout"];
diag_log["run titanic script with params ", _ship, _dir, _pitchBank, _timeout];
//adjust values to time
_dir = _dir vectorMultiply (1/30);
_pitchBank = _pitchBank apply {_x/30};
diag_log["values after adjusting: ", _ship, _dir, _pitchBank, _timeout];

_time = 0;
while {_timeout > _time} do {
    _shipPos = (getPosASL _ship vectorAdd _dir); //update pos
    _ship setPosASL _shipPos; //set new pos
    _time = _time + (1/30);

	//rotate ship
	_shipPitch = (_ship call bis_fnc_getPitchBank)vectorAdd _pitchBank;
	_shipPitch apply {89 min (-89 max _x)};
	[_ship, _shipPitch select 0,0] call BIS_fnc_setPitchBank;
	//systemChat str ["ship pitchbank",_shipPitch,_pitchBank];
    sleep (1/30); //timeout
	[_ship] call _updateShipParts; //mod dependent function to update all shipparts to virtual position.
};

if true exitWith {};
/**
Put this in a man/cars init to trigger the ship sinking on the objects death:
ship has to have variable name of "ship_01"

[this] spawn {
	params["_dude"];
	waitUntil  {sleep 1; !alive _dude};
	[ship_01,[0,0,-0.5],[0.5,0],8] execVM "titanic.sqf";
	sleep 8;
	[ship_01,[0,0,-1],[0.75,0],60] execVM "titanic.sqf";
};

*/
