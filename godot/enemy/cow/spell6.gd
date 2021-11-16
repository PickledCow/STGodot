extends "res://enemy/attack.gd"


var DENSITY = [9,12,16,20]
var DENSITY2 = [9,12,16,18]
var DENSITY3 = [20,30,36,48]
var DENSITY4 = [12,15,20,24]
var DENSITY5 = [6,8,10,12]


var BEND = [16, 16, 18, 18]

var RATE = [21, 18, 15, 12]

var PHASE_TRANSITIONS = [1.0, 0.8, 0.6, 0.35, 0.15]
var TIMINGS = [90, 100, 120, 150]

var y = 1200.0

var phase = 0
var last_phase = 0
var max_health = 0
# delay 480

var t_offset = 0

func _process(delta):
	var pos = parent.position
	var u = t - start_delay - t_offset
	if u == 0:
		max_health = parent.health
	if u >= 0:
		for i in len(PHASE_TRANSITIONS):
			if float( parent.health ) / max_health <= PHASE_TRANSITIONS[i]:
				phase = i
				if phase > last_phase:
					t_offset += u
					Bullets.clear_screen_fade(Vector2(500, 500), 3000, true)
					#root.shoot1.play()
		last_phase = phase
		
		if u % 100 == 0 && phase != 5:
			root.shoot1.play()
			lr *= -1
			var p = pos + Vector2(-lr * rand_range(175, 200), rand_range(-20, 20))
			var o = rad2deg(root.player.position.angle_to_point(p))
			for i in DENSITY[difficulty]:
				var ang = o + (i+lr*0.3) * 360.0 / DENSITY[difficulty]
				for j in  DENSITY2[difficulty]:
					var angle = ang - lr * j * float(BEND[difficulty]) / DENSITY2[difficulty]
					Bullets.create_bullet(p, 4 + j * 5.0 / DENSITY2[difficulty], angle, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL)
		
		var glow_o = randf()*360.0
		if u % 100 == 50 && phase >= 1 && phase != 5:
			root.shoot1.play()
			var o = glow_o
			for i in DENSITY3[difficulty]:
				Bullets.create_bullet(pos, 6.0, o + i * 360.0 / DENSITY3[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
				var b = Bullets.create_bullet(pos, 6.0, o + i * 360.0 / DENSITY3[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.WHITE, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.queue_update_bullet(b, 60, null, null, null, null, null, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.GREEN, true, null, null, BLEND_MODE_MIX)
				
				
		if u % RATE[difficulty] == 0 && u % 300 >= 60 && u % 300 <= TIMINGS[difficulty]+60 && phase >= 2 && phase != 5:
			root.warning1.play()
			var p = pos + Vector2(rand_range(-400, 400), rand_range(-100, 100))
			var o = rad2deg(root.player.position.angle_to_point(p))
			for i in DENSITY4[difficulty]:
				Bullets.create_bullet(p, 5.5, o + (i) * 360.0 / DENSITY4[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN)
					
		
		if u % 100 == 50 && phase >= 3 && phase != 5:
			root.shoot1.play()
			var o = glow_o
			for i in DENSITY3[difficulty]:
				Bullets.create_bullet(pos, 0.0, o + (i+0.5) * 360.0 / DENSITY3[difficulty], 0.2, 6.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
					
		if u % 100 == 60 && phase >= 3 && phase != 5:
			root.shoot1.play()
			
		if u % 100 == 50 && phase >= 4 && phase != 5:
			root.shoot1.play()
			var o = glow_o
			for i in DENSITY3[difficulty]:
				Bullets.create_bullet(pos, 0.0, o + (i) * 360.0 / DENSITY3[difficulty], 0.1, 6.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)
					
		if u % 100 == 70 && phase >= 4 && phase != 5:
			root.shoot1.play()
	t += 1
