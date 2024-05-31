class_name Warden
extends CharacterBody3D

const SPEED = 2
const JUMP_VELOCITY = 4.5

@export var _path: Path3D
@export var _path_timer: Timer
@export var _attack_timer: Timer

@onready var _nav: NavigationAgent3D = $NavigationAgent3D
@onready var _anim: CharacterAnimator = $CharacterAnimator
@onready var disabled: Timer = $DisabledTimer

var _target: Node3D:
	get: return $Sight.target
var _path_point = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	_path_timer.timeout.connect(_on_path_timer_timeout)
	$Visuals.hit.connect(_on_visuals_hit)

func _process(_delta):
	if _target:
		_path_timer.start(5.0)
		_nav.target_position = _target.global_position
	elif _path:
		_nav.target_position = _path.transform * _path.curve.get_point_position(_path_point)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if disabled.time_left: return

	if _nav.is_target_reachable():
		var direction = (_nav.get_next_path_position() - global_position).normalized()
		var distance = global_position.distance_to(_nav.get_next_path_position())
		_anim.rotate_body(direction)
		if distance > _nav.target_desired_distance: # fixme magic number
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity = Vector3.ZERO

	if _attack_timer.time_left:
		_anim.body("idle")
		return

	_anim.body("idle" if velocity.is_zero_approx() else "walk")
	if _target and _nav.is_target_reached():
		attack()
		
	move_and_slide()

func damage(_amount: int):
	_anim.die()
	$Dust.restart()
	disabled.start(100)
	collision_layer = 0
	disabled.timeout.connect(func(): collision_layer=1)

func interact(_interactor): # todo ugly marker function
	pass

func _on_path_timer_timeout():
	if not _path or _target: return
	_path_point = (_path_point + 1) % _path.curve.point_count

func attack():
	if _target.global_position.distance_to(global_position) < 1.0 and not _attack_timer.time_left:
		_anim.attack()
		_attack_timer.start()

func _on_visuals_hit():
	for body in $DamageArea.get_overlapping_bodies():
		if body is Player:
			body.damage(1)
