extends "res://enemy/attack.gd"

var DENSITY = [10, 15, 20, 12]
var DENSITY_D = [1, 1, 2, 2]
var SPEED = [5.0, 6.0, 7.0, 8.0]
var SPEED3 = [2.0, 2.1, 2.25, 2.25]
var SPEED2 = [7, 7.5, 8, 9]
var TIME = [48, 52, 64, 69]
var TIME_D = [2, 2, 3.5, 4.8]
var RATE = [0, 1, 2, 2]
var RATE2 = [0, 1, 2, 2]

var CYCLE_TIME = [240, 240, 240, 240]
var CYCLE_TIME2 = [60, 60, 60, 60]

var dests = [Vector2(500, 250), Vector2(750, 500), Vector2(500, 750), Vector2(250, 500)]

var p = Vector2(0,0)
var p2 = Vector2(0,0)

var ff = 1

func _process(delta):
	var pos = parent.position
	var u = t - start_delay
	if u >= 0:
		var r = 1 if (difficulty == 1 && u % 2 == 0) || ((difficulty == 3 || difficulty == 0) && u % 4 != 0) else 0
		if u % CYCLE_TIME[difficulty] == 0:
			a = 1
			lr *= -1
			p = Vector2(rand_range(0, 500) if lr == -1 else rand_range(500, 1000), rand_range(0, 0))
			if u != 0:
				root.freeze.play()
		if u % CYCLE_TIME2[difficulty] == 0 && u != 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, pos.x - 100 * (pos.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, pos.x + 100 * (1 - pos.x / Constants.FIELD_SIZE.x))  )
			var y = 300
			set_dest(Vector2(x, y), 45)
		if u % CYCLE_TIME[difficulty] == CYCLE_TIME[difficulty] - 60:
			root.charge2.play()
			
		if u % CYCLE_TIME[difficulty] > CYCLE_TIME[difficulty] - 60:
			for i in RATE2[difficulty] + r:
				lr *= -1
				var b = Bullets.create_bullet(pos, rand_range(3, 6), randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, lr * 2, 0.0, BLEND_MODE_ADD)
				Bullets.queue_update_bullet(b, 45, null, null, null, null, null, null, null, false, 0.0)
		if 1:
			root.warning1.play()
			for i in RATE[difficulty] + r:
				var transform_time = CYCLE_TIME[difficulty] - (u % CYCLE_TIME[difficulty])
				var angle = rand_range(0,360)
				var speed = (2.5 + randf()*2.5)*a
				var rot = rand_range(-1, 1) * 0.33
				var pickle = Bullets.create_bullet(pos, speed, angle, 0.0, 0.0, Constants.BULLET_TYPE.SNOWBALL, Constants.COLOURS.TEAL, false, rot)
				var over = Bullets.create_bullet(pos, speed, angle, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL, true, rot)
				Bullets.queue_update_bullet(pickle, transform_time, null, null, null, null, null, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL, true, 0.0)
				Bullets.queue_update_bullet(over, transform_time, null, null, null, null, null, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
				if pickle:
					pickle.sprite_angle += deg2rad(rand_range(-16,16))
				Bullets.queue_autodelete(pickle, 1, false)
				Bullets.queue_autodelete(over, 1, false)
				Bullets.queue_autodelete(pickle, 120, true)
				Bullets.queue_autodelete(over, 120, true)
				var x = sign(cos(deg2rad(angle))) * 10
				Bullets.queue_set_gravity(pickle, transform_time, Vector2(0,SPEED[difficulty]*0.01), Vector2(x,SPEED[difficulty]))
				Bullets.queue_set_gravity(over, transform_time, Vector2(0,SPEED[difficulty]*0.01), Vector2(x,SPEED[difficulty]))
		ff *= -1
		a += 0.0025
	t += 1
