class_name Player
extends CharacterBody3D

@export var _speed = 4.0
@export var _rotation_speed = 0.01

@onready var right_hand_socket: Node3D = $Visuals/RootNode/character_zombie/root/torso/arm_right/RightHandSocket
@onready var _anim: CharacterAnimator = $Animator;
@onready var _cam: FPSCamera = $Camera3D
@onready var _shovel: Node3D = $Camera3D/Shovel

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	PlayerChannel.hid.connect(_on_player_hid)
	PlayerChannel.picked_shovel.connect(_on_player_picked_shovel)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if _anim.animation.begins_with("attack"): return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	# var direction = (%PlayerCamera.right * input_dir.x + %PlayerCamera.forward * input_dir.y).normalized()
	var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized()
	var sprint = Input.is_key_pressed(KEY_SHIFT)
	if direction:
		var target_speed = _speed * 1.5 if sprint else _speed # todo make input
		velocity.x = direction.x * target_speed
		velocity.z = direction.z * target_speed
		# _anim.rotate_body(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)

	_anim.body("idle" if velocity.is_zero_approx() else "walk")

	_cam.target_fov = _cam.SPRINT_FOV if sprint else _cam.NORMAL_FOV
	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("lock_cursor"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseMotion:
		var yaw = event.relative.x
		var pitch = event.relative.y

		var target_rot = clampf(_cam.global_rotation.x - pitch *_rotation_speed, deg_to_rad(-75), deg_to_rad(75))
		_cam.global_rotation.x = target_rot
		global_rotation.y -= yaw * _rotation_speed
		
	elif event.is_action_pressed("interact"):
		handle_interact()
	elif event.is_action_pressed("attack"):
		_anim.torso("attack")
		PlayerChannel.swing()


func _on_player_hid(mode):
	match mode:
		PlayerChannel.Hide.No:
			collision_layer = 1 + (1 << 1)
			EffectsChannel.clear()
			_speed = 0.8
			$Visuals/RootNode/character_zombie/root/torso/head/Pumpkin.visible = false
		PlayerChannel.Hide.Pumpkin:
			collision_layer = 0 
			$Visuals/RootNode/character_zombie/root/torso/head/Pumpkin.visible = true
			PlayerChannel.equip_pumpkin()
		PlayerChannel.Hide.Grave:
			EffectsChannel.grave()
			_speed = 0
	print(collision_layer)


func _on_player_picked_shovel():
	_shovel.visible = true


func handle_interact():
	if $Camera3D/InteractRay.get_collider():
		var interactable = $Camera3D/InteractRay.get_collider()
		if interactable.has_method("interact"):
			interactable.interact(self)
			return
		elif interactable.get_parent().has_method("interact"):
			interactable.get_parent().interact(self)
			return
