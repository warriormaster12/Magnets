extends RayCast2D

class_name MagneticRay

enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES
@export var rayLength: float
@export var rayStrength: float

func _ready():
	self.target_position.x = rayLength

func _physics_process(_delta):
	var collider = get_collider()
	if collider:
		var direction = (self.global_position - collider.global_position).normalized()
		if (collider.is_in_group("NegativePolarity")):
			collider.apply_central_impulse(-direction * rayStrength)
		elif (collider.is_in_group("PositivePolarity")):
			collider.apply_central_impulse(direction * rayStrength)
