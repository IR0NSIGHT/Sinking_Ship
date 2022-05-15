# Sinking_Ship
super small script for ARMA 3 to make a mod ship sink.
## Intended use:
https://steamcommunity.com/sharedfiles/filedetails/?id=1685039592&insideModal=0&requirelogin=1
The above mod brings a large container ship. This script allows to make the ship move and rotate (rather) smoothly.
Original use is to make it sink.

## Usage:
Exec the script with params that specify the ship, the vector to move in, the rotation to do and how long to do it for.
The below code assumes the ship has the variable name of "ship_01"
```sqf
[ship_01,[10,0,-2],[-1,0],10] execVM "titanic.sqf";
```
## Advanced Usage:
Put this in a man/cars init to trigger the ship sinking on the objects death:
ship has to have variable name of "ship_01"
```sqf
[this] spawn {
	params["_dude"];
	waitUntil  {sleep 1; !alive _dude};
	[ship_01,[0,0,-0.5],[0.5,0],8] execVM "titanic.sqf";
	sleep 8;
	[ship_01,[0,0,-1],[0.75,0],60] execVM "titanic.sqf";
};
```

## Showcase:
https://youtu.be/fsYOKd2Jel0
