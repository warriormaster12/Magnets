extends CharacterBody2D

class_name Player

enum PLAYER{Player1=1, Player2=2}
enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES
@export var player: PLAYER

# Movement speed variables
@export var speed:float = 200
@export var acceleration:float = 1000
@export var deceleration:float = 2000

@rpc("call_local")
func set_polarity(value:POLARITIES)->void:
	polarity = value
	print(polarity)

func _enter_tree():
	set_multiplayer_authority(name.to_int())

# Turning speed variables
@export var max_turn_speed = 10.0
@export var min_turn_speed = 2.0

func _process(delta):
	if not is_multiplayer_authority(): return
	# Check for player movement input
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	# Normalize input vector so diagonal movement isn't faster
	if input_vector.length_squared() > 0:
		input_vector = input_vector.normalized()

	# Calculate movement acceleration
	var acceleration_vector = input_vector * acceleration
	velocity = velocity.move_toward(velocity + acceleration_vector * delta, acceleration * delta)

	# Limit velocity to max speed
	velocity = velocity.limit_length(speed)

	# Calculate movement deceleration
	if input_vector == Vector2.ZERO:
		var deceleration_vector = velocity.normalized() * -deceleration
		velocity = velocity.move_toward(Vector2.ZERO, deceleration_vector.length() * delta)

	# Move player
	var node_position = position
	node_position += velocity * delta
	position = node_position
	
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
	self.rotation = new_rotation
