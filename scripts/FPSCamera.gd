class_name FPSCamera
extends Camera3D

const NORMAL_FOV = 75.0
const SPRINT_FOV = 85.0

var target_fov: float = NORMAL_FOV

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta):
	fov = move_toward(fov, target_fov, 100.0 * delta)
	