extends Node3D

@export var target: Node3D
@export var offset: Vector3

var right: Vector3:
	get: return transform.basis.x

var forward: Vector3:
	get: return right.cross(Vector3.UP)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(target.global_position + offset, 0.2)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			$Camera3D.size += .2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera3D.size -= .2
		$Camera3D.size = clampf($Camera3D.size, 2, 6)