class_name MovableObject
extends CharacterBody2D

var PICKUP_DISTANCE = 50
var FROTEMENT_SOL = 1.5
var IMPACT := 0.7
@export_range(0,2,1, "Masse") var masse := 0.0

var original_parent : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_parent = get_parent()
	scale = Vector2(1 + masse, 1 + masse)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity *= 1.0 - FROTEMENT_SOL * delta
	if move_and_slide():
		resolve_collisions()
	
func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * IMPACT
	
func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		velocity -= velocity.project(collision.get_normal())
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)

func _input(event: InputEvent) -> void:
	if !event.is_pressed(): return
	var player = get_tree().get_first_node_in_group("Player")
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if player.grabbed_object == null:
			var mouse_pos = get_global_mouse_position()
			# Distance mouse pos to object
			if global_position.distance_to(mouse_pos) > 5:
				return
			var player_distance = global_position.distance_to(player.global_position)
			if player_distance < PICKUP_DISTANCE:
				# Grab object here
				print("take ", self)
				player.grabbed_object = self
				reparent(player)
				set_collision_layer_value(1,false)
				$Pickup.play(0)
		elif player.grabbed_object == self:
			reparent(original_parent)
			set_collision_layer_value(1,true)
			player.grabbed_object = null
			# Throw object
			var mouse_pos = get_global_mouse_position()
			velocity += global_position.direction_to(mouse_pos) * 200
			$Throw.play(0)
			
func get_points() -> int:
	if masse == 0:
		return 50
	elif masse == 1:
		return 150
	else:
		return 300
