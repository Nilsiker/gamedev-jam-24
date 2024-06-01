extends Node

signal updated(zone)

func update(zone: String):
    updated.emit(zone)