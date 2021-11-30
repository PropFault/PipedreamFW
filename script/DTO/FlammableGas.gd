extends Gas
class_name FlammableGas

var ignitionTemperature = 300; #Celsius
var lowerFlammableLimit = 1; #Percent
var upperFlammableLimit = 10; #Percent
var combustionConsumes = {} #What the gas consumes when it burns. Map (Gas -> mols consumed per mol combustable gas). Combustion will not occur if this is not satisfied
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
	
var ongoingCombustion = null;
const KEY_COMBUSTION_TIME = "combustionTime";
const KEY_COMBUSTION_START = "combustionStart";
const KEY_GAS_TO_REMOVE = "removeableGas";
const KEY_GAS_ALREADY_REMOVED = "removedGas";
const KEY_GAS_TO_ADD = "addableGas";
const KEY_GAS_ALREADY_ADDED = "addedGas";

func _process_internal_heatsource(chamber, effectiveLocalTemperature, delta):
	._process_internal_heatsource(chamber, effectiveLocalTemperature, delta);
	if(effectiveLocalTemperature > ignitionTemperature and ongoingCombustion == null):
		var requirements = {};
		var alreadyRemoved = {};
		#check if all requirements are fully satisfied
		for requirement in combustionConsumes.keys():
			if(not chamber.contents.has(requirement)):
				return;
			var requiredAmount = combustionConsumes[requirement] * chamber.contents[self];
			if requiredAmount > chamber.contents[requirement]:
				return;
			requirements[requirement] = requiredAmount;
			alreadyRemoved[requirements] = 0;
		var results = {};
		var alreadyAdded = {};
		
		for result in combustionProduces.keys():
			results[result] = combustionProduces[result] * chamber.contents[self]; 
			alreadyAdded[result] = 0;
		var pressure = chamber.get_pressure();
		var combustionTime = 1 / pow(_combustionTimeFactorPowBase, combustionTimeFactor * (pressure/1000000));
		ongoingCombustion = {};
		ongoingCombustion[KEY_COMBUSTION_TIME] = combustionTime;
		ongoingCombustion[KEY_COMBUSTION_START] = OS.get_ticks_msec();
		ongoingCombustion[KEY_GAS_TO_REMOVE] = requirements;
		ongoingCombustion[KEY_GAS_TO_ADD] = results;
		ongoingCombustion[KEY_GAS_ALREADY_REMOVED] = alreadyRemoved;
		ongoingCombustion[KEY_GAS_ALREADY_ADDED] = alreadyAdded;
func _process(chamber, delta):
	._process(chamber, delta);
	if not ongoingCombustion == null:
		var elapsedTime = OS.get_ticks_msec() - ongoingCombustion[KEY_COMBUSTION_START];
		var combustionTime = ongoingCombustion[KEY_COMBUSTION_TIME];
		var progress = clamp(elapsedTime/combustionTime,0.0,1.0);
		
		var gasToRemove = ongoingCombustion[KEY_GAS_TO_REMOVE];
		var gasAlreadyRemoved = ongoingCombustion[KEY_GAS_ALREADY_REMOVED];
		
		for gas in gasToRemove.keys():
			var amountRequiredTotal = gasToRemove[gas];
			var amountRequiredNow = amountRequiredTotal * progress;
			var amountAlready = gasAlreadyRemoved[gas];
			var diff = amountRequiredNow - amountAlready;
			if(!chamber.contents.has(gas)):
				chamber.contents[gas] = 0;
			chamber.contents[gas] = chamber.contents[gas] - diff;
		
		var gasToAdd = ongoingCombustion[KEY_GAS_TO_ADD];
		var gasAlreadyAdded = ongoingCombustion[KEY_GAS_ALREADY_ADDED];
		for gas in gasToAdd.keys():
			var amountRequiredTotal = gasToAdd[gas];
			var amountRequiredNow = amountRequiredTotal * progress;
			var amountAlready = gasAlreadyAdded[gas];
			var diff = amountRequiredNow - amountAlready;
			if(!chamber.contents.has(gas)):
				chamber.contents[gas] = 0;
			chamber.contents[gas] = chamber.contents[gas] + diff;
		
		if progress >= 0.99:
			ongoingCombustion = null;
