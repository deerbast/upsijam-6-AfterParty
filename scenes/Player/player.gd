extends CharacterBody2D

signal player_moved

# Player constants
const SPEED_RUN = 80
const SPEED_DASH = 250

# Runtime states
var speed = SPEED_RUN
var dashing: bool = false
var grabbed_object: MovableObject = null

# External refs
@onready var sprite = $AnimatedSprite2D
@onready var dash = $DashTimer 

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed * _speed_modifier()
	if move_and_slide(): resolve_collisions()
	_update_animation()
	emit_signal("player_moved")
	
func _speed_modifier() -> float:
	if grabbed_object != null:
		return (3 - grabbed_object.masse) * 0.3
	return 1

func _update_animation():
	var velo = velocity
	var prefix = "dash-" if dashing else "run-"
	var suffix = "" if grabbed_object == null else "-obj"

	if velo.length() < (SPEED_RUN * 0.1):
		# No movement
		sprite.play("idle"+suffix)
		$Walking.stop()
	else:
		if !$Walking.playing:
			$Walking.play(0)
		if abs(velo.x) > abs(velo.y):
			# Horizontal movement
			sprite.play(prefix+"right"+suffix)
			sprite.flip_h = velo.x < 0
		else:
			# Vertical movement
			var dir = "front" if velo.y > 0 else "rear"
			sprite.play(prefix+dir+suffix)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Dash") and dash.can_dash:
		dashing = true
		speed = SPEED_DASH
		dash.dash()

func _on_dash_finished() -> void:
	dashing = false
	speed = SPEED_RUN
	$Dash.play(0)

# Apply force onto object
func resolve_collisions() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body:
			body.apply_impact(velocity)
			
func blocked(time: float) -> void:
	speed = 0
	$BlockTimer.start(time)

func _on_block_timer_timeout() -> void:
	speed = SPEED_RUN
