extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Play.pressed.connect(_on_play_pressed)
	$Credits.pressed.connect(_on_credits_pressed)
	$Quit.pressed.connect(func(): get_tree().quit())

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/playground.tscn")

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
