extends Node3D

@export var _dust: PackedScene
@export var _dust_point: Node3D
@export var _area: Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerChannel.picked_shovel.connect(_on_player_picked_up)
	PlayerChannel.swung.connect(_on_player_swung)

func _on_player_picked_up():
	visible = true

func _on_player_swung():
	if visible:
		$Swing.play("swing")

func _hit():
	if not _area.get_overlapping_bodies(): return
	print(_area.get_overlapping_bodies())
	for body in _area.get_overlapping_bodies():
		if not body.has_method("damage"): continue
		$Clonk.play()
		$Chime.play()
		var dust = _dust.instantiate() as CPUParticles3D
		get_tree().current_scene.add_child(dust)
		dust.global_position = _dust_point.global_position
		dust.emitting = true
		dust.finished.connect(func(): dust.queue_free())
		body.damage(1)
		visible = false

