extends Camera3D

@export var _speed = 3
@export var _rotation_speed = 0.001

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	global_position += direction * delta * _speed

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var yaw= event.relative.x
		var pitch = event.relative.y

		global_rotation.x -= pitch * _rotation_speed
		global_rotation.y -= yaw * _rotation_speed