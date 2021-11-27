extends Chamber
func get_volume():
	return 1;
func get_pressure():
	return 101325; #1 atmosphere in pascal
func get_total_gas_mols():
	return 1;
	
func release_gas(amount):
	return { air = amount}
	
var air;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(air == null):
		air = Gas.new("Air");
	contents[air] = 999999999;
