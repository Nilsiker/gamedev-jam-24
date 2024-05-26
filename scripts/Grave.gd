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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass