extends Area3D

@export var description: String
@export var one_off: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):	
	if body is Player: 
		print(body)
		MessageChannel.update(description)
		if one_off:
			queue_free()
		
