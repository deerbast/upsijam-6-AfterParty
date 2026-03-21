extends CharacterBody2D

signal player_moved

var speed = 60
var NORMAL_SPEED = 60
var tDASH = 0.25 #Timer
var tENEMY = 2 #Rateau

var grabbed_object: MovableObject = null

signal dash_signal

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
func speed_modifier() -> float:
	if grabbed_object != null:
		return (3 - grabbed_object.masse) * 0.3
	else:
		return 1

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed * speed_modifier()
	if move_and_slide():
		resolve_collisions()
	emit_signal("player_moved")
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Dash"):
		speed = NORMAL_SPEED * 4
		$Timer.start(tDASH)

func _on_timer_timeout() -> void:
	speed = NORMAL_SPEED

#Apply force onto object
func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if viewport.is_in_group("Enemy"):
		$Timer.start(tENEMY)
		speed = NORMAL_SPEED/2
