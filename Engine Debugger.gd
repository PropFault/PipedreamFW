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
		label.parse_bbcode("[b]Pressure: " + chamber.get_pressure() as String + "[/b]");
		label.rect_position = get_viewport().get_camera().unproject_position(chamber.global_transform.origin);
		self.add_child(label)
		labelIndex = labelIndex + 1;
