extends RayCast2D

class_name MagneticRay

enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES
@export var extendUntilWall: bool
@export var rayLength: float
@export var rayStrength: float

func _ready():
	self.target_position.x = rayStrength

func _physics_process(_delta):
	var colliders = get_collider()
	if colliders:
		for collider in colliders:
			if (collider.has_method(POLARITIES)):
				var direction = (self.global_transform - collider.global_transform).normalized()
				var distance = (self.global_transform - collider.global_transform).length()
				var targetPolarity: POLARITIES = collider.POLARITIES
				if (polarity == targetPolarity):
					collider.apply_central_impulse(direction * (1 / distance))
				else:
					collider.apply_central_impulse(-direction * (1 / distance))
