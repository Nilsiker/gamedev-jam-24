extends PanelContainer

@onready var label = $MarginContainer/Message
@onready var fade_timer: Timer = $FadeTimer
@export var _speed: float = 10.0
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	MessageChannel.updated.connect(_on_message_updated)
	fade_timer.timeout.connect(_start_fade)

func _process(delta):
	progress += delta * _speed
	label.visible_characters = progress
	if label.visible_characters >= label.text.length() and not fade_timer.time_left:
		fade_timer.start()
		

var tween: Tween
func _on_message_updated(new_zone: String):
	if tween: 
		tween.kill()
	modulate.a = 1.0
	print(modulate.a)
	progress = 0.0
	label.text = new_zone

func _start_fade():
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)