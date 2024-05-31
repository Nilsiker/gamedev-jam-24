extends Node

enum Hide {
	No,
	Pumpkin,
	Grave
}

signal health_changed(health)
signal hid(mode: Hide)
signal pumpkin_equipped()
signal pumpkin_wither_update(condition: int)
signal pumpkin_withered()
signal picked_shovel
signal swung

var health: int = 2

var timer: SceneTreeTimer
const PUMPKIN_TIMER_MAX = 6

func fire_health_changed(health):
	health_changed.emit(health)

func hide(mode: Hide):
	hid.emit(mode)

func pick_shovel():
	picked_shovel.emit()

func equip_pumpkin():
	pumpkin_equipped.emit()
	timer = get_tree().create_timer(PUMPKIN_TIMER_MAX)
	timer.timeout.connect(_on_timeout)

func swing():
	swung.emit()

func damage(amount):
	health -= amount
	fire_health_changed(health)

func _process(_delta):
	if timer:
		pumpkin_wither_update.emit((timer.time_left / PUMPKIN_TIMER_MAX) * 100.0)

func _on_timeout():
	pumpkin_withered.emit()
	hide(Hide.No)

var debug = 2
func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_P):
		debug -= 1
		if debug < 0:
			debug = 2
		fire_health_changed(debug)
