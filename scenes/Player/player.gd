extends CharacterBody2D

signal player_moved
signal dash_signal

var speed = 100
var dashing: bool = false
var TIMER = 0.25

var grabbed_object: MovableObject = null

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed * speed_modifier()
	if move_and_slide():
		resolve_collisions()
	_update_animation()
	emit_signal("player_moved")
	
func speed_modifier() -> float:
	if grabbed_object != null:
		return (3 - grabbed_object.masse) * 0.3
	else:
		return 1

func _process(delta: float) -> void:
	pass
	
func _update_animation():
	var velo = velocity
	var prefix = "dash-" if dashing else "run-"
	var suffix = "" if grabbed_object == null else "-obj"

	if velo.length() < 10:
		# No movement
		sprite.play("idle"+suffix)
	elif abs(velo.x) > abs(velo.y):
		# Horizontal movement
		sprite.play(prefix+"right"+suffix)
		sprite.flip_h = velo.x < 0
	else:
		# Vertical movement
		var dir = "front" if velo.y > 0 else "rear"
		sprite.play(prefix+dir+suffix)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Dash"):
		speed = 240
		dashing = true
		dash_signal.emit(TIMER)

func _on_timer_timeout() -> void:
	speed = 60
	dashing = false

#Apply force onto object
func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)
