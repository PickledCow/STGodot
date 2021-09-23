extends "res://enemy/attack.gd"

var CYCLE_RATE = [120, 120, 100, 90]
var DENSITY = [24, 30, 45, 48]
var SPEED = [7.5, 10.0, 13.0, 15.0]
var SPEED2 = [3, 4, 4.5, 5]
var RATE = [12, 10, 8, 8]
var RATE2 = [60, 45, 40, 36]

func _process(delta):
	var position = parent.position
	var u = t - start_delay
	if u >= 0:
		if u % CYCLE_RATE[difficulty] == 0:
			lr *= -1
			set_dest(Vector2(500 + lr * rand_range(50, 100), rand_range(250,325)), 90)
			a = -90
		if u % CYCLE_RATE[difficulty] < 90:
			root.laser1.play()
			a += 2.3 * lr
			if u % RATE[difficulty] == 0:
				#Bullets.create_loose_laser(position + 150*Vector2(1, 0).rotated(deg2rad(a)), 16.0, a+60*lr, 1000, 60, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
				#Bullets.create_loose_laser(position + 150*Vector2(1, 0).rotated(deg2rad(a+180)), 16.0, a-60*lr+180, 1000, 60, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.create_curve_laser(position + 150*Vector2(1, 0).rotated(deg2rad(a)), SPEED[difficulty], a+60*lr, 72, 72, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.GREEN, true, SPEED[difficulty]/16.0*lr, BLEND_MODE_ADD, 4)
				Bullets.create_curve_laser(position + 150*Vector2(1, 0).rotated(deg2rad(a+180)), SPEED[difficulty], a-60*lr+180, 72, 72, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.GREEN, true, SPEED[difficulty]/16.0*-lr, BLEND_MODE_ADD, 4)
				
		if u >= CYCLE_RATE[difficulty]:
			if u % RATE2[difficulty] == 0:
				root.shoot1.play()
				for i in DENSITY[difficulty]:
					Bullets.create_bullet(position, SPEED2[difficulty], (i+1) * 360.0/DENSITY[difficulty] + 90, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL_D)
	t += 1
