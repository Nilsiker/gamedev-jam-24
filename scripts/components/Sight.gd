class_name Sight
extends Node3D

@export var _area: Area3D
@export var _ray: RayCast3D
@export var _angle: float

var target: Node3D
var _targets_in_radius: Array[Node3D]

func _ready():
	_area.body_entered.connect(_on_area_body_entered)
	_area.body_exited.connect(_on_area_body_exited)

func _process(_delta):
	_area.get_node("Collider").shape.radius = 10 if target else 6
	_ray.global_position = global_position


	var closest_in_angle = _get_closest_target_in_angle()
	if not closest_in_angle:
		target = null
		return
	_ray.target_position = closest_in_angle.global_position - _ray.global_position
	_ray.rotation = Vector3.ZERO	# TODO hack, why is this needed to orient ray?? 
	if _ray.is_colliding() and _ray.get_collider() is Player: 
		target = _ray.get_collider()
	else: target = null

func _on_area_body_entered(body):
	_targets_in_radius.push_back(body)

func _on_area_body_exited(body):
		var index = _targets_in_radius.find(body)
		_targets_in_radius.remove_at(index)

func _get_closest_target_in_angle():
	var targets_in_angle = _targets_in_radius.filter(_get_in_angle)
	targets_in_angle.sort_custom(_sort_by_distance)

	return targets_in_angle[0] if targets_in_angle else null

func _get_in_angle(a):
	var to = (global_position - a.global_position).normalized()
	var forward = -global_transform.basis.z
	var angle = forward.angle_to(to)
	return rad_to_deg(angle) < _angle
	
func _sort_by_distance(a, b):
	return a.global_position.distance_to(get_parent().global_position) < b.global_position.distance_to(get_parent().global_position)
