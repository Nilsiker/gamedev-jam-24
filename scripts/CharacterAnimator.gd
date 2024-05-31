class_name CharacterAnimator
extends Node3D

@onready var anim: AnimationPlayer = $"../Visuals/AnimationPlayer"
@onready var tree: AnimationTree = $"../Visuals/AnimationTree"

var animation: String:
	get: return anim.current_animation

var move_direction: Vector3

func die():
	tree.set("parameters/Die/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func body(body_anim):
	print(get_parent().name, " ", body_anim)
	if tree["parameters/Body/transition_request"] == body_anim: return
	tree.set("parameters/Body/transition_request", body_anim)

func attack():
	print(get_parent().name, " attack")
	print(tree["parameters/Action/request"])
	tree["parameters/Action/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func rotate_body(direction):
	if direction:
		print(direction)
		var target = global_transform.looking_at(global_position + direction, Vector3.UP, true)
		get_parent().global_transform = get_parent().global_transform.interpolate_with(target, 0.5)