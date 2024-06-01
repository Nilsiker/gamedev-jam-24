extends Area3D

@export_multiline var text: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func interact(interactor):

	print(text)
	
	# if interactor is Interactor:
	print(interactor)
