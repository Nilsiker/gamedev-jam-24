extends ScrollContainer

@export var _credits_scroll_speed: float
@export var _show_last_section := false

var target_scroll: int

func _ready():
	$VBoxContainer/Credits/LastSection.visible = _show_last_section

func _process(delta):
	if visible:
		scroll_vertical = target_scroll
		target_scroll += _credits_scroll_speed * delta
