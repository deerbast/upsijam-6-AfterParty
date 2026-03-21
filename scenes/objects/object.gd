class_name MovableObject
extends CharacterBody2D

# Object constants
const PICKUP_DISTANCE = 30
const FLOOR_FRICTION = 3.0
const IMPACT := 0.7

@export_range(0.1, 2.0, 0.1, "Masse") var masse := 0.1

var _original_parent : Node

@onready var collider = $Collider

func _ready() -> void:
	_original_parent = get_parent()

func _physics_process(delta: float) -> void:
	velocity *= 1.0 - FLOOR_FRICTION * delta * masse
	if move_and_slide():
		resolve_collisions()
	
func apply_impact(impact_velocity: Vector2) -> void:
	velocity += (impact_velocity - velocity) * IMPACT * 1.0/masse
	
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
			# Check click on self
			var shape = collider.shape as RectangleShape2D
			var local_mouse = to_local(get_global_mouse_position())				
			if abs(local_mouse.x) <= shape.extents.x and abs(local_mouse.y) <= shape.extents.y:
				# Check pickup distance
				var player_distance = global_position.distance_to(player.global_position)
				if player_distance < PICKUP_DISTANCE:
					# Grab object here
					print("take ", self)
					player.grabbed_object = self
					reparent(player)
					set_collision_layer_value(1,false)
					$Pickup.play(0)
					
		elif player.grabbed_object == self:
			reparent(_original_parent)
			set_collision_layer_value(1,true)
			player.grabbed_object = null
			# Throw object
			var mouse_pos = get_global_mouse_position()
			velocity += global_position.direction_to(mouse_pos) * 200
			$Throw.play(0)
