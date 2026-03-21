extends Control

var timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = get_parent().get_node("/root/Player/DashTimeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer != null:
		$ProgressBar.value = timer.time_left
