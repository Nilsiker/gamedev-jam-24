extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerChannel.health_changed.connect(func(_h): play())
