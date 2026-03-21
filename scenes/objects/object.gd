class_name MovableObject
extends CharacterBody2D

# Object constants
const DROP_FORCE = 100
const FLOOR_FRICTION = 3.0
const IMPACT := 0.7

@export_range(0.1, 2.0, 0.1, "Masse") var masse := 0.1
@export_range(20, 60, 1, "Pickup Distance") var pickup_distance = 30

var _original_parent : Node

@onready var collider = $Collider

func _ready() -> void:
	_original_parent = get_parent()

func _physics_process(delta: float) -> void:
	velocity *= 1.0 - FLOOR_FRICTION * delta * masse
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

func player_grab_me(player: CharacterBody2D):
	# Grab object here
	player.grabbed_object = self
	reparent(player)
	velocity = Vector2.ZERO
	create_tween().tween_property(self, "position", Vector2(0, -16), 0.1)
	#set_collision_layer_value(1, false)
	
func player_drop_me(player: CharacterBody2D):
	reparent(_original_parent)
	player.grabbed_object = null
	#set_collision_layer_value(1,true)
	var mouse_pos = get_global_mouse_position()
	velocity += global_position.direction_to(mouse_pos) * DROP_FORCE

func _input(event: InputEvent) -> void:
	if !event.is_pressed(): return
	if event is not InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	var player = get_tree().get_first_node_in_group("Player")
	if player.grabbed_object == null:
		# Check click on self
		var shape = collider.shape as RectangleShape2D
		var local_mouse = to_local(get_global_mouse_position())				
		if abs(local_mouse.x) <= shape.extents.x and abs(local_mouse.y) <= shape.extents.y:
			# Check pickup distance
			var player_distance = global_position.distance_to(player.global_position)
			if player_distance < pickup_distance:
				player_grab_me(player)
				$Pickup.play(0)
				
	elif player.grabbed_object == self:
		player_drop_me(player)
		$Throw.play(0)
