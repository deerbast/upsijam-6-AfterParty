extends CharacterBody2D

var is_grabbed : bool = false
var old_mouse_pos : Vector2 = Vector2.ZERO

var SPEED = 200
var PICKUP_DISTANCE = 50

var original_parent : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
					# Grab object here
					reparent(player[0])
					set_collision_layer_value(1,false)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		reparent(original_parent)
		set_collision_layer_value(1,true)
			
		
