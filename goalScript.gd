extends Area2D

@export var pressurePlatesNodes: Array[NodePath] = []


var victoryCondition: bool = false

var pressurePlates:Array[Area2D] = []

var count:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in pressurePlatesNodes:
		pressurePlates.append(get_node(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !victoryCondition:
		for plate in pressurePlates:
			if count == pressurePlates.size():
				victoryCondition = true
			else:
				victoryCondition = false
				if plate.detectBox:
					count += 1
	else:
		print("victory")
