extends Gas
class_name CombustableGas

var ignitionTemperature = 300; #Celsius
var lowerFlammableLimit = 1; #Percent
var upperFlammableLimit = 10; #Percent
var combustionConsumes = {} #What the gas consumes when it burns. Map (Gas -> mols consumed per mol combustable gas)
var combustionProduces = {} #What the gas produces when it burns. 
var combustionTimeFactor = 2 # 1/(_combustionTimeFactorPowBase^(combustionTimeFactor * (pressure/1000000) [megapascal]) = combustion time
var _combustionTimeFactorPowBase = 2.71828; # eulers constant


func _init(displayName, ignitionTemperature, lowerFlammableLimit, upperFlammableLimit, combustionConsumes, combustionProduces, combustionTimeFactor).(displayName):
	self.ignitionTemperature = ignitionTemperature;
	self.lowerFlammableLimit = lowerFlammableLimit;
	self.upperFlammableLimit = upperFlammableLimit;
	self.combustionConsumes = combustionConsumes;
	self.combustionProduces = combustionProduces;
	self.combustionTimeFactor = combustionTimeFactor;

func _process(chamber, delta):
	var temperature = chamber.temperature;
	var pressure = chamber.get_pressure();
	var molAmount = chamber.get_total_gas_mols();
	var combustionTime = 1 / pow(_combustionTimeFactorPowBase, combustionTimeFactor * (pressure/1000000));
	var 
