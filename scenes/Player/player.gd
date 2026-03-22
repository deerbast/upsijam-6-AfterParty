extends CharacterBody2D

signal player_moved

# Player constants
const SPEED_RUN = 80
const SPEED_DASH = 250
const PUSH_FORCE = 0.5

# Runtime states
var speed = SPEED_RUN
var push_slow_factor = 1.0
var dashing: bool = false
var grabbed_object: MovableObject = null

# External refs
@onready var sprite = $AnimatedSprite2D
@onready var dash = $DashTimer
@onready var sprites = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed * _speed_modifier()
	
	move_and_slide()
	update_push_slow_factor(_delta)
		
	_update_animation()
	emit_signal("player_moved")
	
func _speed_modifier() -> float:
	var speed = 1.0
	if grabbed_object != null:
		speed = (3 - grabbed_object.masse) * 0.3
	speed *= push_slow_factor
	return speed

func update_push_slow_factor(_delta: float) -> void:
	# Reset progressively to 1.0
	push_slow_factor = move_toward(push_slow_factor, 1.0, _delta * 2.0)
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		var body := collision.get_collider() as MovableObject
		if body and velocity.dot(-collision.get_normal()) > 0.0:
			var factor = body.masse / 2.0 # [0.05 - 1.0]
			factor *= PUSH_FORCE
			push_slow_factor = min(push_slow_factor, factor)

func _update_animation():
	var velo = velocity
	var prefix = "dash-" if dashing else "run-"
	var suffix = "" if grabbed_object == null else "-obj"

	if velo.length() < 1.0:
		# No movement
		sprite.play("idle"+suffix)
		sprites.speed_scale = 1.0
		$Walking.stop()
	else:
		sprites.speed_scale = velocity.length() / SPEED_RUN
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

			
func blocked(time: float) -> void:
	speed = 0
	$BlockTimer.start(time)

func _on_block_timer_timeout() -> void:
	speed = SPEED_RUN
	
