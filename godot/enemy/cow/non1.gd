extends "res://enemy/attack.gd"

var DENSITY = [6, 10, 12, 12]
var SPACING = [20.0, 16.0, 13.0, 12.0]
var SPEED = [4.0, 5.0, 6.5, 8.0]
var RATE = [24, 18, 12, 9]

func _process(delta):
	var u = t - start_delay
	var position = parent.position
	#if t == 0:
	#	health = 7500
	#	$Healthbar.max_value = health
	#	set_dest(Vector2(500, 300), 60)
	#if u == 0:
	#	invincible = false
	if u >= 0:
		if u % RATE[difficulty] == 0:
			a += 0.15
			var o2 = randf()*360.0
			root.shoot1.play()
			lr *= -1
			var o = (fmod(a, 1.0) - 0.5) * SPACING[difficulty]
			for i in range(1,DENSITY[difficulty]):
				for leftright in range(-1, 2, 2):
					var b = Bullets.create_bullet(position, 10.0, leftright*i*SPACING[difficulty] - 90 + o*lr, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN, true, lr*4.0)
					Bullets.queue_update_bullet(b, 45, null, null, null, -0.25, SPEED[difficulty], null, null, null, 0.0)
				var b = Bullets.create_bullet(position, 10.0, -90 + o*lr, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.GREEN, true, lr*4.0)
				Bullets.queue_update_bullet(b, 45, null, null, null, -0.25, SPEED[difficulty], null, null, null, 0.0)
				#Bullets.queue_update_bullet(b, 135, null, null, null, null, null, null, null, null, lr*6.0)
				#Bullets.queue_update_bullet(b, 150, null, null, null, null, null, null, null, null, -lr*0.5)
		if u % 30 == 0:
			if Globals.player.position.y < 500:
				var o = randf()*360.0
				for i in 120:
					Bullets.create_bullet(position, 2.0, o + i * 3.0, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.TEAL_D)
	t += 1
