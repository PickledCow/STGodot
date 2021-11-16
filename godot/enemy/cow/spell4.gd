extends "res://enemy/attack.gd"


var CYCLE_TIME = [270, 240, 210, 180]
# Killing Floor, Machined Cow
var DENSITY = [12,15,20,26]
var DENSITY2 = [30,36,40,50]
var SPEED = [2.0, 2.0, 2.5, 3.0]
var SPEED2 = [3.0, 3.0, 4.5, 5.0]

func _process(delta):
	var pos = parent.position
	var u = t - start_delay
	if u >= 0:
		if u % (CYCLE_TIME[difficulty] / 3) == 0:
			root.shoot1.play()
			lr *= -1
			var o = randf() * 360.0
			for i in DENSITY[difficulty]:
				var b = Bullets.create_bullet(pos, 15.0, o + i * 360.0 / DENSITY[difficulty], -0.5, SPEED[difficulty], Constants.BULLET_TYPE.SAW, Constants.COLOURS_SAW.BLOOD if randi()% 6 == 0 else Constants.COLOURS_SAW.NORMAL, true, 0.0, lr*2)
				if lr == 1:
					b.sprite_angle = randf()*360.0
				lr *= -1
		if u % CYCLE_TIME[difficulty] == CYCLE_TIME[difficulty]*75/180:
			root.shoot1.play()
			var o = randf() * 360.0
			for i in DENSITY2[difficulty]:
				var b = Bullets.create_bullet(pos, 12.0, o + i * 360.0 / DENSITY2[difficulty], -1, SPEED2[difficulty], Constants.BULLET_TYPE.SAW_SMALL, Constants.COLOURS_SAW.BLOOD if randi()% 6 == 0 else Constants.COLOURS_SAW.NORMAL, true, 0.0, lr*4)
				b.bounce_count = 2
				b.layer = 1
				if lr == 1:
					b.sprite_angle = randf()*360.0
				lr *= -1
		if u % 180 == 90:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, pos.x - 200 * (pos.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, pos.x + 200 * (1 - pos.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.35) * Constants.FIELD_SIZE.y
			#dest = Vector2(x, y) 
			set_dest(Vector2(x, y), 45)
	t += 1
