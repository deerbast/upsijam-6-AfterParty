extends CharacterBody2D

signal player_moved

var speed = 60
var TIMER = 0.25

signal dash_signal

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed
	move_and_slide()
	emit_signal("player_moved")
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Dash"):
		speed = 240
		dash_signal.emit(TIMER)

func _on_timer_timeout() -> void:
	speed = 60
