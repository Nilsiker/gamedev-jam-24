class_name Vignette
extends ColorRect

var PUMPKIN = Color.hex(0x5a2800ff)
var GRAVE = Color.hex(0x20150cff)

# Called when the node enters the scene tree for the first time.
func _ready():
	EffectsChannel.pumpkined.connect(_on_effects_pumpkined)
	EffectsChannel.graved.connect(_on_effects_graved)
	EffectsChannel.cleared.connect(_on_effects_cleared)
	PlayerChannel.pumpkin_wither_update.connect(_on_withering)


func _on_effects_pumpkined():
	material["shader_parameter/outer_radius"] = 0.5
	material["shader_parameter/color"] = PUMPKIN
	visible = true

func _on_effects_graved():
	material["shader_parameter/outer_radius"] = 1
	material["shader_parameter/color"] = GRAVE
	visible = true

func _on_effects_cleared():
	visible = false

func _on_withering(condition):
	material["shader_parameter/outer_radius"] = 2 - condition / 150
	pass

func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_KP_DIVIDE):
		_on_effects_pumpkined()
	elif Input.is_key_pressed(KEY_KP_MULTIPLY):
		_on_effects_graved()
	elif Input.is_key_pressed(KEY_KP_SUBTRACT):
		_on_effects_cleared()