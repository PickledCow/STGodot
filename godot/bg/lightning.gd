extends MeshInstance


func _ready():
	hide()


export var next_strike_timer : float = randf()*10.0

const STRIKE_TIME = 0.25
var strike_timer = 0.0

func _process(delta):
	next_strike_timer -= delta
	if next_strike_timer <= 0:
		show()
		translation.x = -200.0 + randf()*400.0
		strike_timer = STRIKE_TIME
		next_strike_timer = randf()*5.0 + 2.0
	
	strike_timer -= delta
	if strike_timer <= 0:
		hide()
