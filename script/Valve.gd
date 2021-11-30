extends Spatial
class_name Valve
export(NodePath) var chamberAPath;
export(NodePath) var chamberBPath;
export(bool) var open = true;
export(float) var maxThroughput = 10000;
export(float) var minOpenPressureDelta = 100;
onready var chamberA = get_node(chamberAPath);
onready var chamberB = get_node(chamberBPath);
var shape;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _flow(greater, lesser, delta):
	var releasedGas = greater.release_gas_pressure(delta);
	for gas in releasedGas:
		lesser.accept_gas(gas, releasedGas[gas]);
	print("FLOW: ", greater, " -> ", lesser, " FOR ", delta);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(open and chamberA != null and chamberB != null):
		var chamberAPressure = chamberA.get_pressure();
		var chamberBPressure = chamberB.get_pressure();
		print("CHAMBER A ", chamberAPressure, " CHAMBER B ", chamberBPressure);
		print("CHAMBER B STATS: ", chamberB.get_total_gas_mols(), " ", chamberB.get_volume());
		var pressureDelta = chamberAPressure - chamberBPressure;
		var absPressureDelta = abs(pressureDelta);
		var pressureToPass = clamp(absPressureDelta * delta, 0, maxThroughput);
		if(absPressureDelta >= minOpenPressureDelta):
			if(chamberAPressure > chamberBPressure):
				_flow(chamberA, chamberB, pressureToPass);
			elif(chamberBPressure > chamberAPressure):
				_flow(chamberB, chamberA, pressureToPass);
