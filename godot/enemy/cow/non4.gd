extends "res://enemy/attack.gd"

var CYCLE_TIME = 210
var CYCLE_TIME_2 = 120
var CYCLE_TIME_3 = 120
var DENSITY = [12, 20, 26, 30]
var SPEED = [3.0, 4.0, 4.0, 4.0]
var SPEED_2 = [4.0, 4.5, 5.0, 6.0]
var SPEED_3 = [3.0, 4.0, 4.0, 4.0]
var RATE = [20, 15, 12, 10]
var RATE_2 = [36, 36, 30, 30]

func _process(delta):
	var position = parent.position
	
	var u = t - start_delay
	if u >= 0:
		if u % CYCLE_TIME == 0:
			a = rand_range(-1, 1) * 0
		if u % CYCLE_TIME < CYCLE_TIME_2:
			if u % RATE[difficulty] == 0:
				root.shoot1.play()
				for i in DENSITY[difficulty]:
						var b = Bullets.create_bullet(position, SPEED[difficulty], (i+0.5) * 360.0/DENSITY[difficulty] - 90.0 + a, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL_D)
						Bullets.queue_update_bullet(b, Bullets.TRANSFORM_COND.BOUNCE, null, SPEED_2[difficulty])
						if b:
							b.layer = 1
							b.bounce_count = 2
			if (u % CYCLE_TIME) % RATE_2[difficulty] == 15:
				var o = rand_range(-1, 1) * 20 + rad2deg(position.angle_to_point(root.player.position)) + 180.0
				for i in DENSITY[difficulty]:
					Bullets.create_bullet(position, SPEED_3[difficulty], (i) * 360.0/DENSITY[difficulty] - 90.0, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
					Bullets.create_bullet(position, SPEED_3[difficulty], (i) * 360.0/DENSITY[difficulty] - 90.0, 0.0, 0.0, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.GREEN)
					
					
		if (u+1) % CYCLE_TIME == CYCLE_TIME_3+30:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 400 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 400 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range( max(Constants.FIELD_SIZE.y*0.25, position.y - 200 * (position.y / Constants.FIELD_SIZE.y)), min(Constants.FIELD_SIZE.y*0.3, position.y + 200 * (1 - position.y / Constants.FIELD_SIZE.y))  )
			#dest = Vector2(x, y)
			set_dest(Vector2(x, y), 60)

	t += 1
