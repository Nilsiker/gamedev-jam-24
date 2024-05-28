class_name Grave
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var hider = null
var cooldown = 0.25 # todo remove this ugly cooldown handling
var cooling_down = false

func interact(interactor):
	if cooling_down or hider: return
	hider = interactor
	PlayerChannel.hide(PlayerChannel.Hide.Grave)
	hider.global_position = $HidePosition.global_position
	start_cooldown()

func _unhandled_input(event):
	if cooling_down or not hider: return
	if event.is_action_pressed("interact"):
		hider.global_position = $LeavePosition.global_position
		hider = null
		PlayerChannel.hide(PlayerChannel.Hide.No)
		start_cooldown()
		
func start_cooldown():
	cooling_down = true
	get_tree().create_timer(cooldown).timeout.connect(func(): cooling_down=false)
