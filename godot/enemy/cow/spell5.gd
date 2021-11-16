extends "res://enemy/attack.gd"


var CYCLE_TIME = [270, 240, 210, 180]
var RATE = [4,3,2,1]
var MARGIN = [64.0, 64.0, 64.0, 200.0]
var RATE2 = [40,20,14,12]
var DENSITY2 = [25,36,40,52]
var SPEED = [2.0, 2.0, 2.5, 3.0]
var SPEED2 = [3.0, 3.0, 4.5, 5.0]

var MAX_HEIGHT = [650.0, 650.0, 640.0, 625.0]

var y = 1200.0

func _process(delta):
	var pos = parent.position
	var u = t - start_delay
	if u >= 0:
		# RAIN
		if u % RATE[difficulty] == 0:
			root.warning1.play()
			var x = rand_range(-MARGIN[difficulty], 1000+MARGIN[difficulty])
			var s = 4.0 + randf()*3.0
			var b = Bullets.create_bullet(Vector2(x, -64), s, 90.0 + rand_range(-5.0, 5.0), 0.0, 0.0, Constants.BULLET_TYPE.DROPLET, Constants.COLOURS.WHITE)
			if b:
				var time = (y) / int(s)
				Bullets.queue_delete(b, time)
		if u % RATE2[difficulty] == 0 && u > 120:
			var x = rand_range(-64, 1064)
			var s = 4.0 + randf()*3.0
			var b = Bullets.create_bullet(Vector2(x, -64), s, 90.0 + rand_range(-5.0, 5.0), 0.0, 0.0, Constants.BULLET_TYPE.DROPLET, Constants.COLOURS.GREEN)
			if b:
				#Bullets.queue_aim_at_player(b, 30)
				var t = 15 + 45 * (y - 500) / 500
				if x > root.player.position.x:
					Bullets.queue_update_bullet(b, t, null, null, null, null, null, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, 1.0, null, BLEND_MODE_ADD)
				else:
					Bullets.queue_update_bullet(b, t, null, null, null, null, null, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, -1.0, null, BLEND_MODE_ADD)
					
				Bullets.queue_update_bullet(b, t + 30 + 30 * (1000 - y) / 500, null, null, null, null, null, null, null, null, 0.0)
					
				
		
		for _i in (1 + (1000 - y) / 360):
			var corruption = ((1300-y) / 800.0) * 0.5
			
			var b1 = Bullets.create_bullet(Vector2(rand_range(-600, -64), rand_range(y, 1200)), 6.0, 0.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREY if randf() > corruption else Constants.COLOURS_LARGE.GREEN, false, -1.0, 0.0, BLEND_MODE_ADD)
			if b1:
				b1.auto_delete = false
				Bullets.queue_autodelete(b1, 300, true)
				Bullets.queue_update_bullet(b1, 30, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b1, 90, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b1, 150, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b1, 210, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b1, 270, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b1, 360, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b1, 390, null, null, null, null, null, null, null, null, 0.0)
			var b2 = Bullets.create_bullet(Vector2(rand_range(1064, 1600), rand_range(y, 1200)), 6.0, 180.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREY if randf() > corruption else Constants.COLOURS_LARGE.GREEN, false, 1.0, 0.0, BLEND_MODE_ADD)
			if b2:
				b2.auto_delete = false
				Bullets.queue_autodelete(b2, 300, true)
				Bullets.queue_update_bullet(b2, 30, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b2, 90, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b2, 150, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b2, 210, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b2, 270, null, null, null, null, null, null, null, null, -1.0)
				Bullets.queue_update_bullet(b2, 360, null, null, null, null, null, null, null, null, 1.0)
				Bullets.queue_update_bullet(b2, 390, null, null, null, null, null, null, null, null, 0.0)
			
		
		y = max(y - 0.3, MAX_HEIGHT[difficulty])
		
	
		if u % 180 == 90:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, pos.x - 200 * (pos.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, pos.x + 200 * (1 - pos.x / Constants.FIELD_SIZE.x))  )
			#dest = Vector2(x, y) 
			set_dest(Vector2(x, pos.y), 45)

		
	t += 1
