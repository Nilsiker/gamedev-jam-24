extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerChannel.pumpkin_equipped.connect(_on_pumpkin_equipped)
	PlayerChannel.pumpkin_wither_update.connect(_on_pumpkin_withering)
	PlayerChannel.pumpkin_withered.connect(_on_pumpkin_withered)

func _on_pumpkin_equipped():
	visible = true
	value = 100

func _on_pumpkin_withering(condition):
	value = condition

func _on_pumpkin_withered():
	visible = false