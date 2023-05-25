class_name Interactible

extends Node2D

enum POLARITIES{Negative=0, Positive=1, Neutral=2}

@export var polarity: POLARITIES

func _ready():
	if (polarity == POLARITIES.Negative):
		add_to_group("NegativePolarity")
	elif (polarity == POLARITIES.Positive):
		add_to_group("PositivePolarity")
