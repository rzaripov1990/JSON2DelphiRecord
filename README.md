# JSON2DelphiRecord
[FireMonkey] make records from json data

##### ERROR №1
```
{
  "telephones": ["000000000", "111111111111"]
}
```
***CORRECT***
```
{
  "telephones": [{"key":"000000000"}, {"key":"111111111111"}]
}
```

----------

##### ERROR №2
```
[{"index":3},{"index":4},{"index":2},{"index":1}]
```
***CORRECT***
```
{
  "data": [{"index":3},{"index":4},{"index":2},{"index":1}]
}
```

----------

### Simple Object
```
{
  "A": 1,
  "B": "2",
  "C": 1.3,
  "D": false,
  "F": "2014-05-03T03:25:05.059"
}
```
***Output***
```
TmyTypeRecord = record
  A: integer;
  B: string;
  C: float;
  D: boolean;
  F: string;
end;
```
----------

### Objects
```
{"widget": {
    "debug": "on",
    "window": {
        "title": "Sample Konfabulator Widget",
        "name": "main_window",
        "width": 500,
        "height": 500
    },
    "image": { 
        "src": "Images/Sun.png",
        "name": "sun1",
        "hOffset": 250,
        "vOffset": 250,
        "alignment": "center"
    },
    "text": {
        "data": "Click Here",
        "size": 36,
        "style": "bold",
        "name": "text1",
        "hOffset": 250,
        "vOffset": 100,
        "alignment": "center",
        "onMouseUp": "sun1.opacity = (sun1.opacity / 100) * 90;"
    }
}} 
```
***Output***
```
TmyTypeImage = record
  src: string;
  name: string;
  hOffset: integer;
  vOffset: integer;
  alignment: string;
end;

TmyTypeText = record
  data: string;
  size: integer;
  style: string;
  name: string;
  hOffset: integer;
  vOffset: integer;
  alignment: string;
  onMouseUp: string;
end;

TmyTypeWindow = record
  title: string;
  name: string;
  width: integer;
  height: integer;
end;

TmyTypeWidget = record
  debug: string;
  window: TmyTypeWindow;
  image: TmyTypeImage;
  text: TmyTypeText;
end;

TmyTypeRecord = record
  widget: TmyTypeWidget;
end;
```
----------
### Array
```
{"markers": [
		{
			"point": "new GLatLng(40.266044,-74.718479)",
			"homeTeam":"Lawrence Library",
			"awayTeam":"LUGip",
			"markerImage":"images/red.png",
			"information": "Linux users group meets second Wednesday of each month.",
			"fixture":"Wednesday 7pm",
			"capacity":"",
			"previousScore":""
		},
		{
			"point":"new GLatLng(40.211600,-74.695702)",
			"homeTeam":"Hamilton Library",
			"awayTeam":"LUGip HW SIG",
			"markerImage":"images/white.png",
			"information": "Linux users can meet the first Tuesday of the month to work out harward and configuration issues.",
			"fixture":"Tuesday 7pm",
			"capacity":"",
			"tv":""
		},
		{
			"point":"new GLatLng(40.294535,-74.682012)",
			"homeTeam":"Applebees",
			"awayTeam":"After LUPip Mtg Spot",
			"markerImage":"images/newcastle.png",
			"information": "Some of us go there after the main LUGip meeting, drink brews, and talk.",
			"fixture":"Wednesday whenever",
			"capacity":"2 to 4 pints",
			"tv":""
		}
] }
```
***Output***
```
TmyTypeMarkers = record
  point: string;
  homeTeam: string;
  awayTeam: string;
  markerImage: string;
  information: string;
  fixture: string;
  capacity: string;
  tv: string;
end;

TmyTypeRecord = record
  markers: TArray<TmyTypeMarkers>;
end;
```
