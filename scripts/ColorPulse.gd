extends ColorRect

@export var _amplitude: float = 1.0
@export var _speed: float = 1.0
@export var _curve: Curve

var point: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerChannel.health_changed.connect(_on_player_health_changed)
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	point = point + delta * _speed
	if point > 1: point = 0
	var radius = 2 - _curve.sample(point) * _amplitude + _amplitude
	material["shader_parameter/outer_radius"] = radius

func _on_player_health_changed(health):
	if health == 2:
		visible = false
	else:
		_amplitude = 2.0 - health
		material["shader_parameter/alpha"] = (2.0 - health) / 2
		visible = true
