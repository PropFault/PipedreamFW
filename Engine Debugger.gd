extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var chambers = [];
onready var valves = [];
onready var labels = [];


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in self.get_parent().get_children():
		if item.has_method("get_pressure"):
			chambers.append(item)
		if item is Valve:
			valves.append(item)
	

func _make_new_label():
	var newLabel = RichTextLabel.new();
	newLabel.bbcode_enabled = true;
	newLabel.rect_size = Vector2(100,200);
	return newLabel;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var labelIndex = 0;
	for chamber in chambers:
		while(labels.size() <= labelIndex):
			labels.append(_make_new_label());
		var label = labels[labelIndex];
		var text = "[b]Pressure: " + (round(chamber.get_pressure())) as String + "     [/b]";
		for gas in chamber.contents.keys():
			var amount = (round(chamber.contents[gas] * 100)/100.0) as String;
			print(amount)
			print(gas)
			text = text + gas.displayName + " = " + amount + "   ";
		text = text + chamber.name;
		label.parse_bbcode(text);
		label.rect_position = get_viewport().get_camera().unproject_position(chamber.global_transform.origin);
		if(label.get_parent() == null):
			self.add_child(label)
		labelIndex = labelIndex + 1;
