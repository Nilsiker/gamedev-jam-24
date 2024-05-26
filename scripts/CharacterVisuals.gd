extends Node3D

signal hit
signal grab

func hit_trigger():
	hit.emit()


func grab_trigger():
	grab.emit()
