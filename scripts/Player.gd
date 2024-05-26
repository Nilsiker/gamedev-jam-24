class_name Player
extends CharacterBody3D

@export var _speed = 4.0
@onready var right_hand_socket: Node3D = $Visuals/RootNode/character_digger/root/torso/arm_right/RightHandSocket
@onready var anim: CharacterAnimator = $Animator;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	$Visuals.hit.connect(_on_visuals_hit)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if anim.animation.begins_with("attack"): return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (%CameraPivot.right * input_dir.x + %CameraPivot.forward * input_dir.y).normalized()
	# var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		var sprint =  Input.is_key_pressed(KEY_SHIFT)
		var target_speed = _speed * 1.5 if sprint else _speed # todo make input
		velocity.x = direction.x * target_speed
		velocity.z = direction.z * target_speed
		anim.body("sprint" if sprint else "walk")
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)
		anim.body("idle")
	
	anim.rotate_body(direction)
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for area in $InteractArea.get_overlapping_areas():
			if area.has_method("interact"):
				area.interact(self)
				return
			elif area.get_parent().has_method("interact"):
				var anim = area.get_parent().interact(self)
				if anim:
					anim.torso(anim)
	elif event.is_action_pressed("attack"):
		anim.torso("attack")
		

func _on_visuals_hit():
	for body in $DamageArea.get_overlapping_bodies():
		if (body.has_method("damage")):
			body.damage(10)
			$Shovel/Clonk.play()
