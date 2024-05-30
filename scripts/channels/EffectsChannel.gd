extends Node

signal pumpkined
signal graved
signal cleared


func _ready():
    PlayerChannel.pumpkin_equipped.connect(pumpkin)
    PlayerChannel.pumpkin_withered.connect(clear)

func clear():
    cleared.emit()

func pumpkin():
    pumpkined.emit()

func grave():
    graved.emit()
