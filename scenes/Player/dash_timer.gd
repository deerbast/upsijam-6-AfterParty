extends Timer

signal on_dash_finished
signal on_dash_ready

const DASH_TIMER = 0.15
const DASH_COOLDOWN = 0.35

var can_dash: bool = true

var _cooldown: bool = false

func _ready():
	one_shot = true
	timeout.connect(_on_timeout)

func dash():
	assert(can_dash)
	can_dash = false
	start(DASH_TIMER)
	
func _on_timeout():
	if _cooldown:
		# End cooldown
		_cooldown = false
		can_dash = true
		on_dash_ready.emit()
	else:
		# Start cooldown
		_cooldown = true
		start(DASH_COOLDOWN)
		on_dash_finished.emit()
	
