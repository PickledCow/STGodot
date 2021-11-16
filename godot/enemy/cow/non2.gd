extends "res://enemy/attack.gd"

var CYCLE_TIME = 60 * 3
var CYCLE_TIME2 = 60 * 4
var DENSITY = [16, 20, 24, 30, 50]
var DENSITY2 = [30, 60, 80, 92, 120]
var SPEED = [3.0, 3.5, 4.0, 5.0, 5.0]
var RATE = [15, 13, 12, 10, 8]
var RATE2 = [30, 24, 20, 16, 12]
var TIMINGS = [[90, 180, 270], [80, 160, 240], [80, 160, 240], [75, 150, 225], [75, 150, 225]]

func _process(_delta):
	var position = parent.position
	var u = t - start_delay
	if u >= 0:
		if u % CYCLE_TIME2 == 0:
			a = 90.0 + 180.0/DENSITY[difficulty]
		if u % CYCLE_TIME2 < CYCLE_TIME:
			if u % RATE[difficulty] == 0:
				var o = a + rand_range(-1, 1)
				a += lr * 1.0
				root.shoot1.play()
				for i in DENSITY[difficulty]:
					var b = Bullets.create_bullet(position, 8.0, o + i * 360.0/DENSITY[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN, true, lr * 2)
					Bullets.queue_update_bullet(b, TIMINGS[difficulty][0], null, null, null, null, null, null, null, null, -lr*2)
					Bullets.queue_update_bullet(b, TIMINGS[difficulty][1], null, null, null, null, null, null, null, null, lr*1)
					Bullets.queue_update_bullet(b, TIMINGS[difficulty][2], null, null, null, null, null, null, null, null, -lr*1)
			if u % RATE2[difficulty] == 0:
				if u % CYCLE_TIME2 < CYCLE_TIME - 90:
					a2 = randf()*360.0
				else:
					a2 += 180.0 / DENSITY2[difficulty]
				for i in DENSITY2[difficulty]:
					var b = Bullets.create_bullet(position, 4.0, a2 + i * 360.0 / DENSITY2[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL_D)
					if b: b.layer = 1
	
		if u % CYCLE_TIME2 == CYCLE_TIME: lr *= -1
	t += 1
