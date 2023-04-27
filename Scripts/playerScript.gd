extends CharacterBody2D

class_name Player

enum PLAYER{Player1=1, Player2=2}
enum POLARITIES{Negative=0, Positive=1}

@export var polarity: POLARITIES
@export var player: PLAYER

# Movement speed variables
@export var speed = 200
@export var acceleration = 1000
@export var deceleration = 2000

func _process(delta):
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
	
