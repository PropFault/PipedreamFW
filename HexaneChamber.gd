extends Chamber


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	._ready();
	self.contents[GasCommon.new().hexane] = 999999;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
