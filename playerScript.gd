extends Interactible

class_name Player

enum PLAYER{Player1=1, Player2=2}

@export var player: PLAYER

@export var speed = 200

func _process(delta):
	# Check for player input
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

	# Move player
	var node_position = position
	node_position += input_vector * speed * delta
	position = node_position
