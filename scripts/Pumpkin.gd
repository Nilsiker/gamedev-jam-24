extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact(_interactor):
	PlayerChannel.hide(PlayerChannel.Hide.Pumpkin)
	queue_free()