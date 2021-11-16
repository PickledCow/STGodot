extends Sprite

var t = 0

func _process(delta):
	t += delta
	if t > 0.1:
		t -= 0.1
		frame = (frame + 1) % 4
