extends Sprite2D

@export var thisSprite2D: Sprite2D

# Turning speed variables
@export var max_turn_speed = 10.0
@export var min_turn_speed = 2.0

# Magnet ray parameters
@export var magnetPushStrength: float
@export var magnetPullStrength: float
@export var magnetRayLength: float
@export var magnetRayWidth: float
@onready var polarity = get_parent().polarity
@export var rayTexture: Texture2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get the direction to the mouse
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	direction = direction.normalized()

	# Calculate the angle to the mouse
	var angle = direction.angle()

	# Get the current rotation of the player
	var current_rotation = rotation

	# Calculate the shortest angle between the player's current rotation and the target angle
	var shortest_angle = wrapf(angle - current_rotation, -TAU / 2.0, TAU / 2.0)

	# Calculate the turn speed based on the distance from the target angle
	var distance = abs(shortest_angle)
	var turn_speed_ratio = 1.0 - clamp(distance / (TAU / 2.0), 0.0, 1.0)
	var turn_speed = lerp(min_turn_speed, max_turn_speed, turn_speed_ratio)

	# Rotate the player towards the mouse
	var max_rotation = turn_speed * delta
	var new_rotation = current_rotation + sign(shortest_angle) * min(abs(shortest_angle), max_rotation)
	rotation = new_rotation

	# Rotate the child Sprite2D node
	thisSprite2D.rotation = new_rotation
	
	# Creates a detection area infront of the Sprite2D in the direction its facing
	
