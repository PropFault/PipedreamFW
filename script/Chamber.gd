extends Area

tool
class_name Chamber
export(float,0,9999999999.9) var temperature = 30;
var shape;
	

var gasConst = 8.3145
func get_volume():
	return (shape.extents.x * self.scale.x) * (shape.extents.y * self.scale.y) * (shape.extents.z * self.scale.z);
func _calc_pressure(vol, mols,temp):
	return (mols*gasConst*temp)/vol;

func _get_configuration_warnings():
	return "Require your mom";

export(Dictionary) var contents = {}

func accept_gas(var gas, var amount):
	if(!contents.has(gas)):
		contents[gas] = 0.0;
	contents[gas] += amount;
	
func release_gas(var amount):
	var releasedGas = {};
	var totalGas = get_total_gas_mols();
	for gas in contents.keys():
		var ratio = contents[gas] / totalGas;
		var releasedPart = contents[gas] * ratio
		releasedGas[gas] = releasedPart;
		contents[gas] -= releasedPart;
	return releasedGas;
func release_gas_pressure(var pressure):
	return release_gas((pressure * get_volume()) / (gasConst * temperature));
func get_total_gas_mols():
	var molSum = 0;
	for gas in contents:
		molSum += contents[gas];
	return molSum;

func get_pressure(): #in pascal
	return _calc_pressure(get_volume(), get_total_gas_mols(),temperature );
func _init_shape():
	for owner in self.get_shape_owners():
		shape = self.shape_owner_get_shape(owner, 0);
		break;
func _ready():
	_init_shape();
	print("READY")

func _process(delta):
	if(shape == null):
		_init_shape();
		
	#print(get_pressure());
