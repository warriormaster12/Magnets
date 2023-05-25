extends AudioStreamPlayer

@export var RayCast : MagneticRay
var magnet_distance : float
# Called when the node enters the scene tree for the first time.
func _ready():
	playing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collider = RayCast.get_collider()
	var tween = get_tree().create_tween()
	if collider && collider.get_class() == "RigidBody2D":
		tween.stop()
		tween.kill()
		playing = true
		magnet_distance = collider.global_position.distance_to(RayCast.global_position)
		pitch_scale = (RayCast.rayLength / magnet_distance) * 1.25 
	else:
		if pitch_scale <= 0.3:
			playing = false
			tween.stop()
			tween.kill()
			return
		tween.tween_property(self, "pitch_scale", 0, 0.25)
