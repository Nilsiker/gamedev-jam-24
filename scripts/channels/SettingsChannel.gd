extends Node

signal filters_set(enabled: bool)
signal camera_shake_set(enabled: bool)

func set_filters(enabled: bool):
    filters_set.emit(enabled)

func set_camera_shake(enabled: bool):
    camera_shake_set.emit(enabled)
 