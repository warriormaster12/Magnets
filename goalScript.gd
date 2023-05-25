extends Area2D

@export var pressurePlatesNodes: Array[NodePath] = []

var victoryCondition: bool = false

var pressurePlates: Array [Area2D] = []

var players: Array[Player] = []

var count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(5, true) # Set the collision layer(s) you want the pressure plate to interact with
	set_collision_mask_value(5, true) # Set the collision mask(s) for the pressure plate
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
		_checkPlayers()

func _checkPlayers():
	# Called while all plates are active to see if all players are on the goal (this object)
	pass
