@tool
class_name Grave
extends Node3D

@export var open: bool = false
@export_enum("CrossLarge","Cross","Round","Decorative", "Roof", "Wide") var style: String:
	get: return _style
	set(value):
		_style = value
		var whole = $"Gravestone/Whole"
		if whole:
			for child in whole.get_children():
				child.visible = child.name == style
		

var _style: String
var _zombie = preload("res://scenes/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$DropArea.body_entered.connect(_on_drop_area_body_entered)

func drop(_zombie):
	$Mound/Closed.visible = true

func spawn():
	if not $Mound/Closed.visible: return
	$Mound/Closed.visible = false
	$Dust.restart()
	var node = _zombie.instantiate()
	node.global_position = $Dust.global_position
	get_tree().current_scene.add_child(node)


func _input(event):
	if Input.is_key_pressed(KEY_0):
		spawn()

func _on_drop_area_body_entered(body):
	if body is Zombie and not $Mound/Closed.visible:
		$Dust.restart()
		body.queue_free()
		$Mound/Closed.visible = true