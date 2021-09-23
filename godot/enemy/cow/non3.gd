extends "res://enemy/attack.gd"

var CYCLE_TIME = 60 * 3
var DENSITY = [16, 20, 24, 28]
var SPEED = [5.0, 6.0, 7.0, 8.0]
var RATE = [10, 8, 6, 5]

func _process(delta):
	var position = parent.position
	
	var u = t - start_delay
	if u >= 0:
		if u == 0:
			a2 = 0.0
			a = 0.0
		if u % RATE[difficulty] == 0:
			a2 += 1
			a += a2*0.6
			root.shoot1.play()
			for i in DENSITY[difficulty]:
				var ang = a + i * 360.0/DENSITY[difficulty]
				var rot = a2 * 3 - 30.0
				var oset = 50 * Vector2(4 * cos(deg2rad(ang)), sin(deg2rad(ang))).rotated(deg2rad(rot))
				var b = Bullets.create_bullet(position + oset, SPEED[difficulty], ang + rot, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN)
				#Bullets.queue_update_bullet(b, TIMINGS[difficulty][0], null, null, null, null, null, null, null, null, -1)
		
		if (u+1) % CYCLE_TIME == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.4, position.x - 150 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.8, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range( max(Constants.FIELD_SIZE.y*0.25, position.y - 150 * (position.y / Constants.FIELD_SIZE.y)), min(Constants.FIELD_SIZE.y*0.3, position.y + 150 * (1 - position.y / Constants.FIELD_SIZE.y))  )
			#dest = Vector2(x, 300)
			set_dest(Vector2(x, y), 60)
		if u % 30 == 0:
			if Globals.player.position.y < 500:
				var o = randf()*360.0
				for i in 120:
					Bullets.create_bullet(position, 2.0, o + i * 3.0, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL_D)
			
	t += 1
