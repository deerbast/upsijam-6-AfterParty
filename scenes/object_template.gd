extends CharacterBody2D

var is_grabbed : bool = false
var old_mouse_pos : Vector2 = Vector2.ZERO

var SPEED = 200
var PICKUP_DISTANCE = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_grabbed:
		var mouse_pos = get_global_mouse_position()
		# If object to far from player, player can't pick it
		var player = get_tree().get_first_node_in_group("Player").get_children()
		velocity = Vector2.ZERO
		if player.size() != 0:
			var player_char : CharacterBody2D = player[0]
			var player_distance = global_position.distance_to(player_char.global_position)
			if player_distance >= PICKUP_DISTANCE:
				velocity += global_position.direction_to(player_char.global_position) * 2 * SPEED
		velocity += global_position.direction_to(mouse_pos) * SPEED
		move_and_slide()
		old_mouse_pos = mouse_pos
	else:
		old_mouse_pos = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var mouse_pos = get_global_mouse_position()
			if global_position.distance_to(mouse_pos) > 5:
				return
			var player = get_tree().get_first_node_in_group("Player").get_children()
			if player.size() != 0:
				var player_distance = global_position.distance_to(player[0].global_position)
				if player_distance < PICKUP_DISTANCE:
					is_grabbed = true
		if event.is_released():
			is_grabbed = false
		
