extends CharacterBody2D

signal player_moved

var speed = 60
var TIMER = 0.25

signal dash_signal

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	if move_and_slide():
		resolve_collisions()
	emit_signal("player_moved")
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Dash"):
		speed = 240
		dash_signal.emit(TIMER)

func _on_timer_timeout() -> void:
	speed = 60

#Apply force onto object
func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)
