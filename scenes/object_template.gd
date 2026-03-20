extends CharacterBody2D

var is_grabbed : bool = false
var old_mouse_pos : Vector2 = Vector2.ZERO

var SPEED = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_grabbed:
		var mouse_pos = get_global_mouse_position()
		if old_mouse_pos != Vector2.ZERO:
			var direction : Vector2 = mouse_pos - old_mouse_pos
			velocity = direction * SPEED
			move_and_slide()
		old_mouse_pos = mouse_pos
	else:
		old_mouse_pos = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_grabbed = true
		if event.is_released():
			is_grabbed = false
		
