extends Node

signal pumpkined
signal graved
signal cleared

func clear():
    cleared.emit()

func pumpkin():
    pumpkined.emit()

func grave():
    graved.emit()