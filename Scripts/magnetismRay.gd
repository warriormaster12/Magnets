extends RayCast2D

class_name MagneticRay

enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES
@export var extendUntilWall: bool
@export var rayWidth: float
@export var rayLength: float
@export var rayStrength: float

func _ready():
	$RayCast2D.length = rayLength
	$RayCast2D.width = rayWidth
	$RayCast2D.force = rayStrength

func _physics_process(_delta):
	var colliders = get_collider()
	for collider in colliders:
		if (collider.has_method(POLARITIES)):
			var direction = ($RayCast2D.global_transform - collider.global_transform).normalized()
			var distance = ($RayCast2D.global_transform - collider.global_transform).length()
			var targetPolarity: POLARITIES = collider.POLARITIES
			if (polarity == targetPolarity):
				collider.apply_central_impulse(direction * (1 / distance))
			else:
				collider.apply_central_impulse(-direction * (1 / distance))
