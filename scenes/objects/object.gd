class_name MovableObject
extends CharacterBody2D

# Object constants
const DROP_FORCE = 100
const FLOOR_FRICTION = 3.0
const IMPACT := 0.7

var _original_parent: Node
var _grabbed_by: CharacterBody2D = null # Player grabbing the object
var _pickup_distance = 30
var _pickup_height = 10

@export var texture: Texture2D:
	set(value):
		texture = value
		if has_node("Sprite2D"):
			$Sprite2D.texture = value
			_pickup_height = $Sprite2D.texture.get_width()
			_pickup_distance = $Sprite2D.texture.get_width() * 1.8
			print("Set pickup distance of ", _pickup_distance, "for tex ", $Sprite2D.texture)
			
@export_range(0.1, 2.0, 0.1, "Masse") var masse := 0.1

@onready var collider = $Collider

func _ready() -> void:
	_original_parent = get_parent()

func _physics_process(delta: float) -> void:
	velocity *= 1.0 - FLOOR_FRICTION * delta * masse
	if move_and_slide():
		resolve_collisions()
	
	# Set back collisions with player once out of range
	if _grabbed_by != null and\
	 _grabbed_by.grabbed_object == null and\
	!is_overlapping_player(_grabbed_by):
		await get_tree().physics_frame # Temporize slightly
		reset_object_state()
	
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
	# Configure grab
	player.grabbed_object = self
	_grabbed_by = player
	# Parent and collisions
	reparent(player)
	z_index = player.z_index + 1 # Draw above player
	add_collision_exception_with(player)
	player.add_collision_exception_with(self)
	# Move object on top of grabber
	velocity = Vector2.ZERO
	create_tween().tween_property(self, "position", Vector2(0, -_pickup_height), 0.1)
	
func player_drop_me(player: CharacterBody2D):
	# Remove from grabber
	player.grabbed_object = null
	reparent(_original_parent)
	# Drop velocity
	var mouse_pos = get_global_mouse_position()
	velocity += global_position.direction_to(mouse_pos) * DROP_FORCE
	# Collisions are set back once colliders are out 
	
func reset_object_state():
	_grabbed_by.remove_collision_exception_with(self)
	remove_collision_exception_with(_grabbed_by)
	z_index = 0
	print("Set back collision between ", self, " and ", _grabbed_by)
	_grabbed_by = null

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
			if player_distance < _pickup_distance:
				player_grab_me(player)
				$Pickup.play(0)
				
	elif player.grabbed_object == self:
		player_drop_me(player)
		$Throw.play(0)
		
# This function checks if the object overlaps with the player
# even when the collision is removed (exception list)
# It uses the Area2D stored in the player
func is_overlapping_player(player: CharacterBody2D) -> bool:
	var space := get_world_2d().direct_space_state
	assert(collider.shape != null)
	var overlap = player.get_node("OverlapArea")
	assert(overlap != null)
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = collider.shape
	query.transform = collider.global_transform
	query.collide_with_bodies = false
	query.collide_with_areas = true
	query.exclude = [self]

	var results := space.intersect_shape(query)
	for result in results:
		if result.collider == overlap:
			return true
	return false
