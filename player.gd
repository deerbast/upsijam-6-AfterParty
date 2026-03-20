extends CharacterBody2D


## Speed in pixels per second.
@export_range(0, 1000) var speed := 60

const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
