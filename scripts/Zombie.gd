class_name Zombie
extends CharacterBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var anim: AnimationPlayer = $ZombieVisuals/AnimationPlayer

@onready var disabled: Timer = $DisabledTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var target: Node3D

var grabbed: bool: 
	get: return get_parent().name == "Carry"


func _ready():
	$AttentionArea.body_entered.connect(_on_attention_area_body_entered)
	$AttentionArea.body_exited.connect(_on_attention_area_body_exited)

func _process(delta):
	if get_parent().name == "Carry": return
	if target:
		nav.target_position = target.global_position

func _physics_process(delta):
	if get_parent().name == "Carry": return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if disabled.time_left: return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not nav.is_target_reachable() or nav.is_target_reached(): return

	var direction = (nav.get_next_path_position() - global_position).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_at(global_position + Vector3(direction.x, 0, direction.z), Vector3.UP, true)
		anim.play("walk",0.25)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim.play("idle", 0.25)

	move_and_slide()

func damage(amount: int):
	anim.play("die")
	$Dust.restart()
	disabled.start(2)

func interact(_interactor): # todo ugly marker function
	pass

func _on_attention_area_body_entered(body):
	if body is Player:
		target = body

func _on_attention_area_body_exited(body):
	if body is Player:
		target = null