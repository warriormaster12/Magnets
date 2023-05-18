extends Area2D

var objectsToDetect = []

enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(4, true) # Set the collision layer(s) you want the pressure plate to interact with
	set_collision_mask_value(4, true) # Set the collision mask(s) for the pressure plate
	self.body_entered.connect(_on_PressurePlate_body_entered)
	self.body_exited.connect(_on_PressurePlate_body_exited)

func _on_PressurePlate_body_entered(body: Node) -> void:
	if body.is_in_group("TriggersPlates"):
		if (polarity == POLARITIES.Negative && body.is_in_group("PositivePolarity")) || (polarity == POLARITIES.Positive && body.is_in_group("NegativePolarity")):
			objectsToDetect.append(body)
			# Handle the state change here when a specific object enters the collision area

func _on_PressurePlate_body_exited(body: Node) -> void:
	if body.is_in_group("TriggersPlates"):
		if (polarity == POLARITIES.Negative && body.is_in_group("PositivePolarity")) || (polarity == POLARITIES.Positive && body.is_in_group("NegativePolarity")):
			objectsToDetect.erase(body)
			# Handle the state change here when a specific object exits the collision area
