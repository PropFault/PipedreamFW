extends Chamber
func get_volume():
	return 1;
func get_pressure():
	return 101325; #1 atmosphere in pascal
func get_total_gas_mols():
	return 1;
onready var gasCommon = GasCommon.new();
func release_gas(amount):
	var gas = {};
	gas[gasCommon.Nitrogen] = amount/2;
	gas[gasCommon.Oxygen] = amount/2;
	return gas;
	
var air;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	._process(delta);
	contents[gasCommon.Nitrogen] = 999999999;
	
	contents[gasCommon.Oxygen] = 999999999;
