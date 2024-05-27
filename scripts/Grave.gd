class_name Grave
extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var hider = null

func interact(interactor):
	hider = interactor
	PlayerChannel.hide(PlayerChannel.Hide.Grave)
	hider.global_position = $HidePosition.global_position
	hider.global_rotation = $HidePosition.global_rotation

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and hider:
		hider.global_position = $LeavePosition.global_position
		hider.global_rotation = $LeavePosition.global_rotation
		hider = null
		PlayerChannel.hide(PlayerChannel.Hide.No)
