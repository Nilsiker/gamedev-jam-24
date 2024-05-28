extends Node

enum Hide {
	No,
	Pumpkin,
	Grave
}

signal health_changed(health)
signal hid(mode: Hide)
signal picked_shovel
signal swung

func fire_health_changed(health):
	health_changed.emit(health)

func hide(mode: Hide):
	hid.emit(mode)

func pick_shovel():
	picked_shovel.emit()

func swing():
	swung.emit()

var debug = 2
func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_P):
		debug -= 1
		if debug < 0:
			debug = 2
		fire_health_changed(debug)