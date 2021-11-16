extends "res://enemy/attack.gd"

var DENSITY = [14, 18, 20, 24]
var DENSITY_D = [1, 1, 2, 2]
var SPEED = [3, 4, 5, 6]
var SPEED3 = [2.0, 2.1, 2.25, 2.25]
var SPEED2 = [7, 7.5, 8, 9]
var TIME = [48, 52, 64, 69]
var TIME_D = [2, 2, 3.5, 4.8]
var RATE = [180, 180, 180, 180]

var CYCLE_TIME = 500

var dests = [Vector2(500, 250), Vector2(750, 500), Vector2(500, 750), Vector2(250, 500)]

func _process(delta):
	var pos = parent.position
	var u = t - start_delay
	if u >= 0:
		if u % CYCLE_TIME == 0:
			a = randf()*360.0
			a2 += 1
			lr = 1 if difficulty < 2 else (randi()%2)*2-1
		if u % CYCLE_TIME < (TIME[difficulty] + a2 * int(TIME_D[difficulty])):
			if u % 6 == 0:
				root.shoot1.play()
				var w = u * 0.1
				var r = min(u, 128)
				for i in (DENSITY[difficulty] + a2*DENSITY_D[difficulty]):
					var ang = a + i * 360.0 / (DENSITY[difficulty] + a2)
					var b = Bullets.create_bullet(pos, SPEED[difficulty], ang, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN)
					
					if b:
						b.bounce_count = 1
						b.bounce_top = true
						b.bounce_bottom = true
					Bullets.queue_aim_at_player(b, Constants.TRANSFORM_COND.BOUNCE)
					Bullets.queue_update_bullet(b, Constants.TRANSFORM_COND.BOUNCE, null, SPEED3[difficulty])
					for j in 2:
						var dir = (j*2-1)
						b = Bullets.create_bullet(pos, SPEED[difficulty], ang, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN)
						
						if b:
							b.bounce_count = 1
							b.bounce_top = true
							b.bounce_bottom = true
						Bullets.queue_aim_at_player(b, Constants.TRANSFORM_COND.BOUNCE)
						Bullets.queue_update_bullet(b, Constants.TRANSFORM_COND.BOUNCE, null, SPEED3[difficulty])
						Bullets.queue_offset_angle(b, Constants.TRANSFORM_COND.BOUNCE, dir*60)
			
		
		if difficulty >= 2 && u % 60 == 0 && u == -1:
			var angle = 180.0 + rad2deg(pos.angle_to_point(root.player.position))
			Bullets.create_bullet(pos, SPEED2[difficulty], angle, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
			var b = Bullets.create_bullet(pos, SPEED2[difficulty], angle, 0.0, 0.0, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.GREEN)
			if b: b.layer = 1
		if u % 6 == 6:
			Bullets.create_bullet(Vector2(-96, 980), 5.0, 0.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(1096, 980), 5.0, 180.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(-96, 20), 5.0, 0.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(1096, 20), 5.0, 180.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(980, -96), 5.0, 90.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(980, 1096), 5.0, -90.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(20, -96), 5.0, 90.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
			Bullets.create_bullet(Vector2(20, 1096), 5.0, -90.0, 0.0, 0.0, Constants.BULLET_TYPE.ICE_LARGE, Constants.COLOURS_LARGE.GREY)
		
		if u % CYCLE_TIME == (TIME[difficulty] + a2 * int(TIME_D[difficulty] + 30)):
			set_dest(dests[a2 % 4], 90)
		
		a += 0.25 * lr
	t += 1
