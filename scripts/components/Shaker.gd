class_name Shaker
extends Node

# screen shake functions taken from https://kidscancode.org/godot_recipes/3.x/2d/screen_shake/index.html

@export var decay_time = 2 # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75) # Maximum hor/ver shake in pixels.

var _trauma = 0.0 # Current shake strength.
var _trauma_power = 3 # Trauma exponent. Use [2, 3].
var _rumbling: float = 0.0

@onready var _target: Node3D = get_parent()
@onready var original_position: Vector3 = _target.position

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	PlayerChannel.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(_health):
	_trauma = 0.2

func _process(delta):
	if _trauma > 0:
		var decay_rate = 0.5 / decay_time
		_trauma = max(_trauma - decay_rate * delta, _rumbling)
		shake()
		
func shake():
	var amount = pow(_trauma, _trauma_power)
	_target.position.x = original_position.x + max_offset.x * amount * randf_range( - 1, 1)
	_target.position.y = original_position.y + max_offset.y * amount * randf_range( - 1, 1)