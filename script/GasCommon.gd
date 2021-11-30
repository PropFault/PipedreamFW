extends Node

class_name GasCommon

var Oxygen = Gas.new("oxygen");
var Nitrogen = Gas.new("nitrogen");
var h20 = Gas.new("h2o");
var co2 = Gas.new("co2");
var hexane = FlammableGas.new("hexane", 300, 1, 10, {Oxygen = 6.5, nitrogen = 26}, {h2o = 7, co2 = 6, nitrogen = 26}, 2);

func _init():
	Oxygen = Gas.new("oxygen");
	Nitrogen = Gas.new("nitrogen");
	h20 = Gas.new("h2o");
	co2 = Gas.new("co2");
	hexane = FlammableGas.new("hexane", 300, 1, 10, {Oxygen = 6.5, nitrogen = 26}, {h2o = 7, co2 = 6, nitrogen = 26}, 2);
