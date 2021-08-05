extends Node2D

var t = 0
var health = 20000

var phase = 0

onready var root = get_node('../')
onready var Bullets = root.get_node("BulletHandler")

func _ready():
	weight = 30
	dest = Vector2(Constants.FIELD_SIZE.x * 0.5, Constants.FIELD_SIZE.y * 0.3)
	position = dest
	$Healthbar.max_value = health


#create_bullet(position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend)

var dest = position
var weight = 30


var c_offset = 0

func bowap():
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var DENSITY = 14.0
	var u = t - 180
	if u >= 0:
# warning-ignore:shadowed_variable
		var lr = -1 if u % 1200 >= 600 else 1
# warning-ignore:shadowed_variable
		var a = lr*pow((u%600)-30,2)*0.031
		
		#1.61803398875
		
		if u % 600 == 0:
			c_offset = randi()%7
		
		if u % 120 == 60:
			dest = Vector2(Constants.FIELD_SIZE.x * (0.2+randf()*0.6), Constants.FIELD_SIZE.y * (0.3+randf()*0.1))
		
		root.warning1.play()
		if u % 3 == 0:
			for i in range(DENSITY):
				var angle = a + i * 360.0 / DENSITY
				Bullets.create_bullet(position + Vector2(64, 0).rotated(deg2rad(angle) * 1.61803398875), 4, angle, 0.0, 0.0, Constants.BULLET_TYPE.AMULET, COLOURS[(i+c_offset)%7]) 


func bowap2():
	position.y = Constants.FIELD_SIZE.y * 0.333
	dest.y = Constants.FIELD_SIZE.y * 0.333
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var DENSITY = 14.0
# warning-ignore:shadowed_variable
	var lr = -1 if t % 1200 >= 600 else 1
# warning-ignore:shadowed_variable
	var a = lr*pow((t%600)-30,2)*0.051
	var r = 96
	
	#1.61803398875
	
	if t % 600 == 0:
		c_offset = randi()%7
	
	if t % 120 == 120:
		dest = Vector2(Constants.FIELD_SIZE.x * (0.2+randf()*0.6), Constants.FIELD_SIZE.y * (0.3+randf()*0.1))
	
	if t % 2 == 0:
		for i in range(DENSITY):
			var angle = a + i * 360.0 / DENSITY
			Bullets.create_bullet(position + Vector2(r, 0).rotated(deg2rad(angle) * 1.61803398875), 3, angle, 0.0, 0.0, Constants.BULLET_TYPE.ICE, Constants.COLOURS.BLUE) 



func misdirection():
	var x = [0.8, 0.5, 0.2, 0.5]
	
	var u = t - 180
	if u >= 0:
		if u % 180 < 120 && u % 5 == 0:
# warning-ignore:shadowed_variable
			var a = rad2deg(root.player.position.angle_to_point(position))
			for i in range(21):
				var b = Bullets.create_bullet(position, 4, a + i * 360.0/21.0, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.RED)
				b.bounce_count = 1
				Bullets.queue_update_bullet(b, Constants.TRANSFORM_COND.BOUNCE, null, null, null, null, null, null, Constants.COLOURS.BLUE)
		
		if u % 180 == 60:
			weight = 30
			dest = Vector2(Constants.FIELD_SIZE.x * x[(u%960)/180], Constants.FIELD_SIZE.y*0.3)
		
func qed():
	if t % 120 == 0:
# warning-ignore:shadowed_variable
		var p = Constants.FIELD_SIZE * 0.5 + Vector2(1,0).rotated(randf()*360.0) * randf()*128.0 + Vector2(0, - 150)
# warning-ignore:shadowed_variable
		var a = randf()*360.0
		for i in range(150):
			var b = Bullets.create_bullet(p, 2, a + i * 360.0/150.0, 0.0, 0.0, Constants.BULLET_TYPE.JELLYBEAN, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD);
			Bullets.queue_update_bullet(b, 60, null, null, null, null, null, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE, true, null, null, BLEND_MODE_MIX);
			if b: b.bounce_count = 1

func qed2():
	if t % 60 == 0:
# warning-ignore:shadowed_variable
		var p = Constants.FIELD_SIZE * 0.5 + Vector2(1,0).rotated(randf()*360.0) * randf()*64.0 + Vector2(0, - 150)
# warning-ignore:shadowed_variable
		var a = randf()*360.0
		for i in range(10):
			for j in range(6):
				var b1 = Bullets.create_bullet(p, 3, a + i * 360.0/10.0 + 6 - j, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE);
				if b1: b1.bounce_count = 1
				var b2 = Bullets.create_bullet(p, 3, a + i * 360.0/10.0 - 6 + j, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE);
				if b2: b2.bounce_count = 1
			var b = Bullets.create_bullet(p, 3, a + i * 360.0/10.0, 0.0, 0.0, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE);
			if b: b.bounce_count = 1
	
func water():
	var u = t - 180
	if u >= 0:
		root.warning1.play()
		if u % 3 != 0:
			var angle = rad2deg(Bullets.player.position.angle_to_point(position)) + rand_range(-1, 1) * 10#90 + 60 * sin(t*0.01 - PI*0.5) + rand_range(-1, 1) * 20
			var x = rand_range(-0.01, 1.01) * Constants.FIELD_SIZE.x
			var y = rand_range(-96, -32)
			var b = Bullets.create_bullet(Vector2(x, y), rand_range(8.0, 10.0), rand_range(80.0, 100.0), -0.15, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 60, null, null, angle, 0.1, rand_range(5.0, 8.0))
		
		if u % 120 == 60:
			dest = Vector2(Constants.FIELD_SIZE.x * rand_range(0.2, 0.8), Constants.FIELD_SIZE.y*rand_range(0.2,0.35))
			
		if u % 120 == 90:
			root.laser1.play()
			#create_curve_laser(position: Vector2, speed, angle, length, width, accel, max_speed, type, colour, _fade=true, w_vel = 0.0, blend=BLEND_MODE_MIX):
# warning-ignore:shadowed_variable
			var a = rad2deg(Bullets.player.position.angle_to_point(position))
			var l1 = Bullets.create_curve_laser(position, 10, a + 180, 60, 96, -0.075, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 2.3, BLEND_MODE_ADD)
			Bullets.queue_update_curve_laser(l1, 90, null, null, null, 2, 20.0, null, null, null, 0.0)
			Bullets.queue_aim_at_player(l1, 90)
			var l2 = Bullets.create_curve_laser(position, 10, a + 180, 60, 96, -0.075, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, -2.3, BLEND_MODE_ADD)
			Bullets.queue_update_curve_laser(l2, 90, null, null, null, 2, 20.0, null, null, null, 0.0)
			Bullets.queue_aim_at_player(l2, 90)

var lr = 1

func fire():
	var colours = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.ORANGE]
	var u = t - 180
	if u >= 0:
		if u % 360 < 180 && u % 3 == 0:	
			if u % 6 == 0:
				root.shoot1.play()
			Bullets.create_bullet(position, rand_range(4, 8), randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.RED, false, 0.0, 137, BLEND_MODE_ADD)
		
		if u % 360 < 210:
			root.warning1.play()
# warning-ignore:unused_variable
			for i in range(3):
				var b = Bullets.create_bullet(position, 3 + randf()*1, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, colours[randi()%2], true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.queue_update_bullet(b, 60, null, null, null, null, null, null, null, null, lr * (rand_range(1.5,1.75)))
				Bullets.queue_update_bullet(b, 120, null, null, null, null, null, null, null, null, 0.0)
				#
				lr *= -1
func firewily():
	var colours = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.ORANGE]
	var difficulty = 3
	var u = t - 120
	var CYCLE_TIME = 600
	var CYCLE_TIME2 = 540
	if u >= 0:
		var changes = [rand_range(5,7), rand_range(3,5), rand_range(2,4), rand_range(2,4)]
		var speeds = [rand_range(2,3.5), rand_range(2.5,4.5), rand_range(3,6), rand_range(3,6)]
		var rates = [1 if u % 3 == 0 else 0, 1 if u % 3 != 0 else 0, 1, 2 if u % 4 == 0 else 1]
		if u % CYCLE_TIME == 0:
			a = 0 if u % (CYCLE_TIME * 2) == 0 else 180
		if u % CYCLE_TIME < 540:
			root.warning1.play()
			
			for _i in range(rates[difficulty]):
				var b = Bullets.create_bullet(position + Vector2(-350, 250), speeds[difficulty], -a, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, colours[randi()%2], true, 0.0, 0.0, BLEND_MODE_ADD)
				b = Bullets.create_bullet(position + Vector2(350, 250), speeds[difficulty], a, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, colours[randi()%2], true, 0.0, 0.0, BLEND_MODE_ADD)
				a += changes[difficulty]
	
var a = 0.0	
var a2 = 0.0
var a3 = 0.0
var a4 = 0.0

func shark():
	weight = 20
	var u = (t-60) % 720
	if u >= 0 && u < 360:
		if (u) % 90 == 0:
			dest = (root.player.position - position).normalized()*640 + position
			dest.x = clamp(dest.x, 0.05 * Constants.FIELD_SIZE.x, 0.95 * Constants.FIELD_SIZE.x)
			dest.y = clamp(dest.y, 0.05 * Constants.FIELD_SIZE.y, 0.95 * Constants.FIELD_SIZE.y)
			$Sprite.rotation = dest.angle_to_point(position)
			$Sprite.scale.y = 1 if abs(rotation) < PI*0.5 else -1
		if (u) % 90 <= 45 && u >= 0:
			for _i in 2:
				Bullets.create_bullet(position, rand_range(8.0, 16.0), $Sprite.rotation_degrees + rand_range(-20.0, 20.0), 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			for _i in 1:
				Bullets.create_bullet(position, rand_range(16.0, 24.0), $Sprite.rotation_degrees + rand_range(-10.0, 10.0), 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)

		if (u) % 90 == 45 && u >= 0:
			a = randf()*360.0
			lr *= -1
		if (u) % 90 >= 45 && u >= 0:
			for _i in 4:
				a += lr * 3
				Bullets.create_bullet(position, rand_range(4.0, 6.0), a + rand_range(-1.0, 1.0), 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.BLUE)
	elif u >= 360:
		if u == 360:
			dest = Vector2(Constants.FIELD_SIZE.x * 0.5, Constants.FIELD_SIZE.y * 0.3)
			$Sprite.rotation = dest.angle_to_point(position)
			$Sprite.scale.y = 1 if abs(rotation) < PI*0.5 else -1
		if u == 420:
			$Sprite.rotation = 0
			$Sprite.scale.y = 1
		if u >= 450 && u <= 600 && u % 10 == 0:
			for i in range(1):
				var b = Bullets.create_straight_laser(position + Vector2($Sprite.scale.x*$eye1.position.x, $eye1.position.y), 0, 750, 48, 30, 60, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, 0.0, BLEND_MODE_ADD)
				Bullets.aim_at_player(b)
				b = Bullets.create_straight_laser(position + Vector2($Sprite.scale.x*$eye2.position.x, $eye2.position.y), 0, 750, 48, 30, 60, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, 0.0, BLEND_MODE_ADD)
				Bullets.aim_at_player(b)
				#root.create_loose_laser(position + Vector2(scale.x*$eye1.position.x, $eye1.position.y), 12, ['at player', i*15], 360, 32, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
				#root.create_loose_laser(position + Vector2(scale.x*$eye2.position.x, $eye2.position.y), 12, ['at player', i*15], 360, 32, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 0.0, 0.0, BLEND_MODE_ADD)

		
func test_ndl():
	if t % 120 == 0:
		for i in 10:
			Bullets.create_straight_laser(position, i * 36, 900, 96, 60, 75, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE, 0.5, BLEND_MODE_ADD)
	
	if t % 120 == 60:
		for i in 10:
			Bullets.create_straight_laser(position, i * 36, 900, 96, 60, 75, Constants.BULLET_TYPE.RICE, Constants.COLOURS.RED, -0.5, BLEND_MODE_ADD)


func spark():
	if t % 30 == 1:
		for _i in 1:
# warning-ignore:shadowed_variable
			var a = rad2deg(root.player.position.angle_to_point(position))
			Bullets.create_straight_laser(position, a, 900, 1200, 60, 120, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, 0.0, BLEND_MODE_ADD)

func dbdb():
	var u = t - 180
	if u >= 0:
		if u % 12 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.1, position.x - 200), min(Constants.FIELD_SIZE.x*0.9, position.x + 200)  )
			var y = rand_range(0.3, 0.4) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
			for _i in 4:
				var s1 = rand_range(3,12)
				var s2 = rand_range(3,12)
				var a1 = randf()*360.0
				var a2 = randf()*360.0
				for i in 4:
					var b = Bullets.create_bullet(position, s1, a1 + i * 360 / 8.0, -0.01*s1, 0.0, Constants.BULLET_TYPE.BUTTERFLY, Constants.COLOURS_LARGE.BLUE)
					var b2 = Bullets.create_bullet(position, s2, a2 + i * 360 / 8.0, -0.01*s2, 0.0, Constants.BULLET_TYPE.BUTTERFLY, Constants.COLOURS_LARGE.RED)
					Bullets.queue_update_bullet(b, 150, null, null, null, 0.02, 4.0, null, null, null, 1)
					Bullets.queue_update_bullet(b, 480, null, null, null, null, null, null, null, null, 0)
					Bullets.queue_update_bullet(b2, 150, null, null, null, 0.02, 4.0, null, null, null, -1)
					Bullets.queue_update_bullet(b2, 480, null, null, null, null, null, null, null, null, 0)
				for i in 8*0:
					var b = Bullets.create_loose_laser(position, s1, a1 + i * 360 / 8.0, 128, 32, -0.01*s1, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.BLUE, true,  0.0, 0.0,BLEND_MODE_ADD)
					var b2 = Bullets.create_loose_laser(position, s2, a2 + i * 360 / 8.0, 128, 32,-0.01*s2, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
					Bullets.queue_update_bullet(b, 150, null, null, null, 0.02, 6.0, null, null, null, 1)
					Bullets.queue_update_bullet(b, 480, null, null, null, null, null, null, null, null, 0)
					Bullets.queue_update_bullet(b2, 150, null, null, null, 0.02, 6.0, null, null, null, -1)
					Bullets.queue_update_bullet(b2, 480, null, null, null, null, null, null, null, null, 0)

func kanko():
	var u = t - 180
	if u >= 0:
		if u % 180 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.4, position.x - 50), min(Constants.FIELD_SIZE.x*0.5, position.x + 50)  )
			var y = rand_range(0.3, 0.4) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
		if u % 60 < 40 && u % 6 == 0:
			root.warning1.play()
			for i in range(-5,5):
				var b = Bullets.create_bullet(position, 8.0, 0.0, -0.15, 0.0, Constants.BULLET_TYPE.AMULET, Constants.COLOURS.RED)
				Bullets.aim_at_player(b)
				Bullets.offset_angle(b, 30 * (i + 0.5) + rand_range(-2, 2))
				Bullets.queue_update_bullet(b, 120 - (u % 60)/2, null, null, null, 0.15, 8.0, null, Constants.COLOURS.WHITE)
				Bullets.queue_aim_at_player(b, 120)
				Bullets.queue_offset_angle(b, 120, -30 * i)
				Bullets.queue_update_bullet(b, 180 - (u % 60), null, null, null, -0.15, 0.0)
				Bullets.queue_update_bullet(b, 180 - 3*(u % 60)/2, null, null, null, 0.15, 8.0, null, Constants.COLOURS.PURPLE)
				Bullets.queue_aim_at_player(b, 180)
			

func bls():
	var rate = 0.1
	var u = t - 180
	if u >= 0:
		if u % 32 == 0 || u % 32 == 11:
			for i in 8:
				Bullets.create_bullet(Vector2(0, Constants.FIELD_SIZE.y), 4, rate*u + i * 360 / 8, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)	

		if u % 32 == 8 || u % 32 == 19:
			for i in 8:
				Bullets.create_bullet(Vector2(Constants.FIELD_SIZE.x, 0), 4, rate*u + i * 360 / 8, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.GREEN, true, 0.0, 0.0, BLEND_MODE_ADD)	

		if u % 32 == 16 || u % 32 == 27:
			for i in 8:
				Bullets.create_bullet(Vector2(Constants.FIELD_SIZE.x, Constants.FIELD_SIZE.y), 4, rate*u + i * 360 / 8, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)	

		if u % 32 == 24 || u % 32 == 3:
			for i in 8:
				Bullets.create_bullet(Vector2(0, 0), 4, rate*u + i * 360 / 8, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.YELLOW, true, 0.0, 0.0, BLEND_MODE_ADD)	

func chimata():
	position.y = Constants.FIELD_SIZE.y * 0.5
	dest.y = Constants.FIELD_SIZE.y * 0.5
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var u = t - 180
	if u >= 0:
		if u % 900 == 899:
			lr *= -1
		a += 0.7 * lr
		if u % 8 == 0:
			for i in 7:
				var angle = a + i * 360.0 / 8.0 + rand_range(-2, 2) - 80
				Bullets.create_bullet(position + Vector2(-512, 0).rotated(deg2rad(angle)), 3.0, angle, 0.0, 0.0, Constants.BULLET_TYPE.DROPLET, COLOURS[i%7])

func meek():
	for _i in 20:
		Bullets.create_bullet(position, rand_range(5.0, 10.0), randf()*350.0, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE)



func funny_junko2():
	dest.y = Constants.FIELD_SIZE.y * 0.2
	var density = 60.0
	#Bullets.create_bullet(position, rand_range(3,4), randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE)
	
	var u = t - 180
	
	if u >= 0:
		var time = min(30 + int(u * 0.03), 130)
# warning-ignore:unused_variable
		var time2 = max(180-u*0.05, 90)
		$Sprite2.scale = Vector2(1,1) * (time * 0.06 + sin(u*0.02) * 0.1)
		
		$Sprite2.rotation += 0.1
		if u % 30 == 0:
			root.shoot1.play()
			lr *= -1
# warning-ignore:shadowed_variable
			var a = randf()*360.0
			for i in range(density):
				var b = Bullets.create_bullet(position, 3, a + i*360.0/density, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
				if b:
					b.auto_delete = false
				Bullets.queue_update_bullet(b, time, null, null, null, null, null, null, null, null, 1 * lr)
				Bullets.queue_update_bullet(b, time + (90)/1, null, null, null, null, null, null, null, null, 0.0)
				Bullets.queue_autodelete(b, 600, true)
		
		a += 1
		
		if a >= time2:
			root.laser1.play()
			a = 0
			var pos = position - Vector2(300,0)
			var ang = rad2deg(root.player.position.angle_to_point(pos))
			Bullets.create_loose_laser(pos, 8, ang, 480, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			pos = position + Vector2(300,0)
			ang = rad2deg(root.player.position.angle_to_point(pos))
			Bullets.create_loose_laser(pos, 8, ang, 480, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)

func rainbarf():
	if t % 120 <= 30:
		for _i in 2:
			Bullets.create_bullet(Vector2(rand_range(-0.1,1.1)*Constants.FIELD_SIZE.x, rand_range(-0.1,0.3) * Constants.FIELD_SIZE.y), rand_range(3,8), rand_range(60,120), 0.0, 0.0, Constants.BULLET_TYPE.DROPLET, Constants.COLOURS.BLUE)
			Bullets.create_bullet(Vector2(rand_range(-0.1,1.1)*Constants.FIELD_SIZE.x, rand_range(-0.1,0.3) * Constants.FIELD_SIZE.y), rand_range(3,8), rand_range(60,120), 0.0, 0.0, Constants.BULLET_TYPE.DROPLET, Constants.COLOURS.CYAN)
		#Bullets.create_loose_laser(position + Vector2(randf()*Constants.FIELD_SIZE.x, rand_range(-0.1,0.3) * Constants.FIELD_SIZE.y), rand_range(70,110), 90, 320, 32, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED)
	
func bullet_test():
	if t % 30 == 0:
		Bullets.create_bullet(position, 2.0, 90, 0.0, 0.0, Constants.BULLET_TYPE.NOTE, Constants.COLOURS_LARGE.GREY, true, 0.0, 0.2)
		#Bullets.create_loose_laser(position, 5, 90, 320, 32, 0.0, 0.0, Constants.BULLET_TYPE.LEGACY_LASER, Constants.COLOURS.RED)
		#Bullets.create_curve_laser(position, 7, 90, 75, 32, -0.01, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 0.0, BLEND_MODE_ADD)

func ds():
	var u = t - 180
	if u >= 0:
		if u % 270 == 0:
			root.laser1.play()
# warning-ignore:shadowed_variable
			var a = rad2deg(root.player.position.angle_to_point(position)) + rand_range(-8, 8)
			for i in 5:
				var l = Bullets.create_curve_laser(position, 7, a-90 - i * 20, 90, 32, -0.008, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.RED, true, 0.5, BLEND_MODE_ADD)
				Bullets.queue_update_curve_laser(l, 85, null, null, null, 0.1, 20, null, null, null, 3.0 + i*0.6)
				Bullets.queue_update_curve_laser(l, 115, null, null, null, null, null, null, null, null, 0.5)
				l = Bullets.create_curve_laser(position, 7, a+90 + i * 20, 90, 32, -0.008, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, -0.5, BLEND_MODE_ADD)
				Bullets.queue_update_curve_laser(l, 85, null, null, null, 0.1, 20, null, null, null, -3.0 - i*0.6)
				Bullets.queue_update_curve_laser(l, 115, null, null, null, null, null, null, null, null, -0.5)
		if u % 270 < 180:
			root.warning1.play()
			if u % 2 == 0:
				var b = Bullets.create_bullet(position, rand_range(1,10), randf()*360.0, -0.075, 2.5, Constants.BULLET_TYPE.REST, Constants.COLOURS_LARGE.RED)
				Bullets.queue_update_bullet(b, 120, null, null, 90)
				b = Bullets.create_bullet(position, rand_range(1,10), randf()*360.0, -0.075, 2.0, Constants.BULLET_TYPE.REST, Constants.COLOURS_LARGE.BLUE)
				Bullets.queue_update_bullet(b, 120, null, null, 90)
			else:
				var b = Bullets.create_bullet(position, rand_range(1,10), randf()*360.0, -0.075, 2.5, Constants.BULLET_TYPE.NOTE, Constants.COLOURS_NOTE.RED)
				Bullets.queue_update_bullet(b, 120, null, null, 90)
				b = Bullets.create_bullet(position, rand_range(1,10), randf()*360.0, -0.075, 2.0, Constants.BULLET_TYPE.NOTE, Constants.COLOURS_NOTE.BLUE)
				Bullets.queue_update_bullet(b, 120, null, null, 90)
		if u % 270 == 180:	
			dest = Vector2(Constants.FIELD_SIZE.x * (0.2+randf()*0.6), Constants.FIELD_SIZE.y * (0.2+randf()*0.1))

func ds2():
	var u = t - 180
	if u >= 0:
		if u % 30 == 0:
			root.laser1.play()
# warning-ignore:shadowed_variable
			var a = rad2deg(root.player.position.angle_to_point(position)) + rand_range(-30, 30)*0.1
			for i in 5:
				var l = Bullets.create_curve_laser(position, 7, a-90 - i * 20, 40, 32, -0.01, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.RED, true, 0.5, BLEND_MODE_ADD, 4)
				Bullets.queue_update_curve_laser(l, 65, null, null, null, 0.1, 20, null, null, null, 3.0 + i*0.6)
				Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, 0.5)
				l = Bullets.create_curve_laser(position, 7, a+90 + i * 20, 40, 32, -0.01, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, -0.5, BLEND_MODE_ADD, 4)
				Bullets.queue_update_curve_laser(l, 65, null, null, null, 0.1, 20, null, null, null, -3.0 - i*0.6)
				Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, -0.5)

		if u % 30 == 15:	
			dest = Vector2(Constants.FIELD_SIZE.x * (0.2+randf()*0.6), Constants.FIELD_SIZE.y * (0.2+randf()*0.1))



func satorinon1():
	var u = t - 60
	if u >= 0:
		var r = (u % 600) / 600.0 * 150 + 100
		var a1 = (u % 600) * 21
		var a2 = (u % 600) * -11+50
		var a3 = (u % 600) * 137 + 10
		if u % 600 < 360:
			root.shoot1.play()
			if u % 1 == 0:
				for i in 3:
					Bullets.create_bullet(position + Vector2(r, 0). rotated(deg2rad(a1 - 90 + i * 120)), 8, 90+a2 + i * 0, -0.3, 2.5, Constants.BULLET_TYPE.RICE, Constants.COLOURS.RED)
					Bullets.create_bullet(position + Vector2(r, 0). rotated(deg2rad(-a1 - 90 + i * 120)), 8, 90-a2 + i * 0, -0.3, 2.5, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE)
			if u % 10 == 0:
				for i in 3:
					Bullets.create_bullet(position, 10, 90+a3 + i * 120, -0.3, 2.5, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.RED, true, 0.0, 137.5077640500378546463487, BLEND_MODE_ADD)
					Bullets.create_bullet(position, 10, 90-a3 + i * 120, -0.3, 2.5, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.BLUE, true, 0.0, -137.5077640500378546463487, BLEND_MODE_ADD)
		
		if u % 600 == 360:
			dest = Vector2(Constants.FIELD_SIZE.x * (0.2+randf()*0.6), Constants.FIELD_SIZE.y * (0.2+randf()*0.15))


func satorinon2():
	var D1 = 20
	var D2 = 12*1
	var D3 = 10
	var skew = 25
	var u = t - 180
	var TOTAL = 600
	if u >= 0:
		if u % TOTAL == 0:
			lr *= -1
			a = 32.0 * lr
		if u % TOTAL < 60:
			root.shoot1.play()
			for i in D1:
				Bullets.create_bullet(position + Vector2((120 - a*lr*0.05) * cos(deg2rad(a+(i*360/D1))), (120 - a*lr*0.05) * sin(deg2rad(a+(i*360/D1)))), 10, (2-a*0.0001*lr)*a+(i*360/D1)+180-10*lr, -0.15*(1-a*0.00025*lr), 2, Constants.BULLET_TYPE.RICE, Constants.COLOURS.PURPLE)
			a += 20 * lr
		if u % TOTAL == 60:
			a -= 400*lr
		if u % TOTAL >= 125 && u % TOTAL < 245 && u % 2 == 0:
			root.shoot1.play()
			for i in D2:
				Bullets.create_bullet(position + Vector2((80 - a*lr*0.05) * cos(deg2rad(a+(i*360/D2)+skew*lr)), (80 - a*lr*0.05) * sin(deg2rad(a+(i*360/D2)+skew*lr))), 10, 1.5*(1.75-a*0.0001*lr)*a+(i*360/D2)+180+10*lr+skew*lr, -0.16*(1-a*0.0005*lr), 2, Constants.BULLET_TYPE.RICE, Constants.COLOURS.PURPLE)
			a += 13 * lr
		if u % TOTAL >= 245 && u % TOTAL < 360:
			root.shoot1.play()
			for i in D2:
				Bullets.create_bullet(position + Vector2((80 - a*lr*0.05) * cos(deg2rad(a+(i*360/D2)+skew*lr)), (80 - a*lr*0.05) * sin(deg2rad(a+(i*360/D2)+skew*lr))), 10, 1.5*(1.75-a*0.0001*lr)*a+(i*360/D2)+180+10*lr+skew*lr, -0.06, 2, Constants.BULLET_TYPE.RICE, Constants.COLOURS.PURPLE)
			a -= 13 * lr
		if u % TOTAL >= 360 && u % TOTAL < 450:
			root.shoot1.play()
			for i in D3:
				Bullets.create_bullet(position + Vector2((80 - a*lr*0.05) * cos(deg2rad(a+(i*360/D3))), (80 - a*lr*0.05) * sin(deg2rad(a+(i*360/D3)))), 10, 1.5*(1.75-a*0.0001*lr)*a+(i*360/D2)+180+10*lr, -0.125, 2, Constants.BULLET_TYPE.RICE, Constants.COLOURS.PURPLE)
			a -= 13 * lr
		if u % TOTAL == 450:
			dest = Vector2(Constants.FIELD_SIZE.x * (0.3+randf()*0.4), Constants.FIELD_SIZE.y * (0.2+randf()*0.15))
			
func pl():
	var DENSITY = 30
	var u = t - 180
	if u >= 0:
		if u % 200 == 0:
			root.laser1.play()
			var o = randf()*360.0
			for i in DENSITY:
				var l = Bullets.create_curve_laser(position, 4, o + i * 360.0 / DENSITY, 120, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 3, BLEND_MODE_ADD, 12)
				Bullets.queue_update_curve_laser(l, 60, null, null, null, null, null, null, null, null, -4.0)
				Bullets.queue_update_curve_laser(l, 150, null, null, null, null, null, null, null, null, 0.0)
				Bullets.queue_update_curve_laser(l, 220, null, null, null, null, null, null, null, null, -4.0)
				Bullets.queue_update_curve_laser(l, 250, null, null, null, null, null, null, null, null, 4.0)
				Bullets.queue_update_curve_laser(l, 280, null, null, null, null, null, null, null, null, 0.0)
		elif u % 200 == 100:
			root.laser1.play()
			var o = randf()*360.0
			for i in DENSITY:
				var l = Bullets.create_curve_laser(position, 4, o + i * 360.0 / DENSITY, 120, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.PURPLE, true, -3, BLEND_MODE_ADD, 12)
				Bullets.queue_update_curve_laser(l, 60, null, null, null, null, null, null, null, null, 4.0)
				Bullets.queue_update_curve_laser(l, 150, null, null, null, null, null, null, null, null, 0.0)
				Bullets.queue_update_curve_laser(l, 220, null, null, null, null, null, null, null, null, 4.0)
				Bullets.queue_update_curve_laser(l, 250, null, null, null, null, null, null, null, null, -4.0)
				Bullets.queue_update_curve_laser(l, 280, null, null, null, null, null, null, null, null, 0.0)
			
func pl2():
	var DENSITY = 50
	var u = t - 180
	if u >= 0:
		if u % 120 == 0:
			root.laser1.play()
			var o = randf()*360.0
			for i in DENSITY:
				var l = Bullets.create_curve_laser(position, 8, o + i * 360.0 / DENSITY, 72, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.RED, true, 2, BLEND_MODE_ADD, 6)
				Bullets.queue_update_curve_laser(l, 60, null, null, null, null, null, null, null, null, -8.0)
				Bullets.queue_update_curve_laser(l, 80, null, null, null, null, null, null, null, null, 8.0)
				Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, -8.0)
				Bullets.queue_update_curve_laser(l, 120, null, null, null, null, null, null, null, null, 8.0)
				Bullets.queue_update_curve_laser(l, 140, null, null, null, null, null, null, null, null, -8.0)
				Bullets.queue_update_curve_laser(l, 160, null, null, null, null, null, null, null, null, 0.0)
		elif u % 120 == 60:
			root.laser1.play()
			var o = randf()*360.0
			for i in DENSITY:
				var l = Bullets.create_curve_laser(position, 8, o + i * 360.0 / DENSITY, 72, 48, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.PURPLE, true, -2, BLEND_MODE_ADD, 6)
				Bullets.queue_update_curve_laser(l, 60, null, null, null, null, null, null, null, null, 8.0)
				Bullets.queue_update_curve_laser(l, 80, null, null, null, null, null, null, null, null, -8.0)
				Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, 8.0)
				Bullets.queue_update_curve_laser(l, 120, null, null, null, null, null, null, null, null, -8.0)
				Bullets.queue_update_curve_laser(l, 140, null, null, null, null, null, null, null, null, 8.0)
				Bullets.queue_update_curve_laser(l, 160, null, null, null, null, null, null, null, null, 0.0)

var laser_container = []
var laser_container2 = []

func thunder():
	var a_s = 1.61803398875 # [-137.5077640500378546463487, 45]
	var u = t - 180
	if posmod(u, 210) == 180:
		root.charge1.play()
	if u >= 0:
		if u % 210 == 0:
			lr *= -1
			laser_container.clear()
			a = randf()
			#root.charge2.play()
		if u % 210 < 60 && u % 2 == 0:
			var arr = []
			#var b = Bullets.create_straight_laser(position, a[j], 900, 32, 90, 1, Constants.BULLET_TYPE.LASER, Constants.COLOURS.WHITE, 0.0, BLEND_MODE_ADD)
# warning-ignore:shadowed_variable
			var p = Vector2(Constants.FIELD_SIZE.x * fmod(a, 1), -30.0)
			var b = Bullets.create_straight_laser(p, rand_range(85,95), 1200, 32, 90, 1, Constants.BULLET_TYPE.LASER, Constants.COLOURS.WHITE, 0.0, BLEND_MODE_ADD)
			arr.append(b)
			a += a_s# * lr
			laser_container.append(arr)
		
		if u % 210 == 75:
			laser_container2.clear()
			root.rumble2.play()
		
		if u % 210 >= 75 && u % 210 < 75+60:
			root.laser1.play()
			#root.shoot3.play()
# warning-ignore:shadowed_variable
			var a = laser_container[(u%210-75)/2]
			for b in a:
				var l = Bullets.create_loose_laser(b.position, rand_range(30,45), rad2deg(b.angle), rand_range(900, 1200), 80, 0.0, 0.0, Constants.BULLET_TYPE.LIGHTNING, 0, true, 0.0, 0.0, BLEND_MODE_ADD)
				laser_container2.append([l, 12])
		
		var dev = 15
		
		for i in laser_container2:
			i[1] -= 1
			var b = i[0]
			if i[1] >= 0 && !b.free:
				if i[1] % 6 == 0:
					Bullets.create_bullet(b.position, 8, rad2deg(b.angle) + dev + rand_range(-1, 1) * 15, -0.1, 3.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
				elif i[1] % 6 == 3:
					Bullets.create_bullet(b.position, 8, rad2deg(b.angle) - dev + rand_range(-1, 1) * 15, -0.1, 3.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)

		
func thunder2():
	var a_s = [-137.5077640500378546463487, 45]
	var u = t - 180
	if posmod(u, 180) == 150:
		root.charge1.play()
	if u >= 0:
		if u % 180 == 0:
			lr *= -1
			laser_container.clear()
			a = [randf()*360.0, 90+30*lr, randf()*360.0]
			#root.charge2.play()
		if u % 180 < 60:
			var arr = []
			for j in 2:
				var b = Bullets.create_straight_laser(position, a[j], 900, 32, 90, 1, Constants.BULLET_TYPE.LEGACY_LASER, Constants.COLOURS.BLUE, 0.0, BLEND_MODE_ADD)
				arr.append(b)
				a[j] += a_s[j]# * lr
			laser_container.append(arr)
		
		if u % 180 == 75:
			laser_container2.clear()
			root.rumble2.play()
			root.rumble1.play()
		
		if u % 180 >= 75 && u % 180 < 75+60:
			root.laser1.play()
			#root.shoot3.play()
# warning-ignore:shadowed_variable
			var a = laser_container[u%180-75]
			for b in a:
				var l = Bullets.create_loose_laser(b.position, 40, rad2deg(b.angle), rand_range(900, 1200), 80, 0.0, 0.0, Constants.BULLET_TYPE.LIGHTNING, 0, true, 0.0, 0.0, BLEND_MODE_ADD)
				laser_container2.append([l, 12])
		
		var dev = 90
		
		for i in laser_container2:
			i[1] -= 1
			var b = i[0]
			if i[1] >= 0 && !b.free:
				if i[1] % 5 == 0:
					Bullets.create_bullet(b.position, 3, rad2deg(b.angle) + dev, -0.2, 2.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
				elif i[1] % 5 == 2:
					Bullets.create_bullet(b.position, 3, rad2deg(b.angle) - dev, -0.2, 2.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)

	
func tsukasa():
	var RADIUS = 128
	var DENSITY = 36.0
	var BUFFER = 4.0
	var WAVE_DURATION = 60*10
	var D_W = 0.24
	var u = t - 180
	if u >= 0 && u % WAVE_DURATION <= WAVE_DURATION - 60:
		if u % WAVE_DURATION == 0:
			lr *= -1
		if u % 12 == 0:
			root.shoot1.play()
			var a1 = lr*max(((u) % WAVE_DURATION)*D_W-60*D_W, 0)
			var a2 = lr*max(((u) % WAVE_DURATION)*D_W-60*D_W, 0) + 180
			for i in range(BUFFER, DENSITY-BUFFER):
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a1)), 6, (i+0.5) * 360 / DENSITY + a1 + 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.GREEN)
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a2)), 6, (i+0.5) * 360 / DENSITY + a2 - 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.GREEN)

			for i in range(-BUFFER+1, BUFFER-1):
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a1)), 4, (i+0.5) * 360 / DENSITY + a1 + 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.YELLOW)
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a2)), 4, (i+0.5) * 360 / DENSITY + a2 - 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.YELLOW)

func tsukasa2():
	var RADIUS = 128
	var DENSITY = 40.0
	var BUFFER = 4.0
	var WAVE_DURATION = 60*15
	var D_W = 0.24
	var u = t - 180
	if u >= 0 && u % WAVE_DURATION <= WAVE_DURATION - 60:
		if u % WAVE_DURATION == 0:
			lr *= -1
		if u % 12 == 0:
			root.shoot1.play()
			var a1 = lr*max(((u) % WAVE_DURATION)*D_W-60*D_W, 0)
			var a2 = lr*max(((u) % WAVE_DURATION)*D_W-60*D_W, 0) + 180
			for i in range(BUFFER, DENSITY-BUFFER):
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a1)), 6, (i+0.5) * 360 / DENSITY + a1 + 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.GREEN)
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a2)), 6, (i+0.5) * 360 / DENSITY + a2 - 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.GREEN)

			for i in range(-BUFFER+1, BUFFER-1):
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a1)), 4, (i+0.5) * 360 / DENSITY + a1 + 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.YELLOW)
				Bullets.create_bullet(position + Vector2(RADIUS, 0).rotated(deg2rad(a2)), 4, (i+0.5) * 360 / DENSITY + a2 - 90, 0.0, 0.0, Constants.BULLET_TYPE.KUNAI, Constants.COLOURS.YELLOW)


func mek():
	for i in range(-25, 26):
		Bullets.create_bullet(position, rand_range(6,12), -90 + 18 * sin(t*0.01) + 0* rad2deg(root.player.position.angle_to_point(position)) + i*8.9 + rand_range(-4, 4), 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.RED_D, true, 0.0, 0.1)

var p = Vector2()

func wraparound():
	var u = t - 120
	if u >= 0:
		var CYCLE_TIME = 60*6
		var BUFFER_TIME = 60*4
		
		if u % CYCLE_TIME == 0:
			lr *= -1
			p = root.player.position
			
		var r = (u % CYCLE_TIME) * 1 + 300
		var density = (u % CYCLE_TIME) / 8 + 10
# warning-ignore:shadowed_variable
		var a = 4 * lr * (u % CYCLE_TIME)
		
		if u % 6 == 0 && u % CYCLE_TIME < CYCLE_TIME - BUFFER_TIME:
			root.shoot1.play()
			for i in density:
				var b = Bullets.create_bullet(p + Vector2(r, 0).rotated(deg2rad(a)), 1, a + 360 * i / float(density), 0.0, 0.0, Constants.BULLET_TYPE.BACTERIA, Constants.COLOURS.PURPLE_D)
				b.auto_delete = false
				Bullets.queue_autodelete(b, 120, true)
				b = Bullets.create_bullet(p + Vector2(r, 0).rotated(deg2rad(a) + PI), 1, a + 360 * i / float(density), 0.0, 0.0, Constants.BULLET_TYPE.BACTERIA, Constants.COLOURS.PURPLE_D)
				b.auto_delete = false
				Bullets.queue_autodelete(b, 120, true)
func speen():
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60*6
		var BUFFER_TIME = 60*0.5
		var DENSITY = 24
		var RADIUS = 180
		
		if u % CYCLE_TIME == 0:
			lr *= -1
			p = root.player.position
			
		a += lr * 370/60.0
		
		if u % 3 == 0 && u % CYCLE_TIME < CYCLE_TIME - BUFFER_TIME:
			var c = (u/3) % 7
			for i in DENSITY:
				var b = Bullets.create_bullet(p + Vector2(RADIUS, 0).rotated(deg2rad(a)), 0, a + 360 * i / float(DENSITY), 0.01, 1.0, Constants.BULLET_TYPE.RICE, COLOURS[c])
				b.auto_delete = false
				Bullets.queue_autodelete(b, 120, true)
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.05, 3.0)
				if i <= 10 || i > DENSITY - 10:
					Bullets.queue_delete(b, 120)
				Bullets.queue_delete(b, 300)
				#position: Vector2, angle, length, width, delay, time, type, colour
			Bullets.create_straight_laser(p + Vector2(RADIUS, 0).rotated(deg2rad(a)), a + 90, 1500, 32, 30, 60, Constants.BULLET_TYPE.LEGACY_LASER, COLOURS[c], 0.0, BLEND_MODE_ADD)
			Bullets.create_straight_laser(p + Vector2(RADIUS, 0).rotated(deg2rad(a)), a - 90, 1500, 32, 30, 60, Constants.BULLET_TYPE.LEGACY_LASER, COLOURS[c], 0.0, BLEND_MODE_ADD)
			Bullets.create_straight_laser(p + Vector2(RADIUS, 0).rotated(deg2rad(a)), a, 1500, 32, 30, 60, Constants.BULLET_TYPE.LEGACY_LASER, COLOURS[c], 0.0, BLEND_MODE_ADD)


func war_of_the_roses():
	var u = t - 180
	if u >= 0:
		var RATE1 = 50
		var RATE2 = 60
		var CYCLE_TIME = 60*1
		var SPEED = 3.0
		var SPEED2 = 2.0
		var R1 = 36
		var R2 = 48
		var DELAY = 45
		var DELAY2 = 20
		var DENSITY = 21
		if u % RATE1 == 0:
			root.warning1.play()
			#var c = Constants.COLOURS_LARGE.RED if u % 24 == 0 else Constants.COLOURS_LARGE.GREY
# warning-ignore:shadowed_variable
			var p = Vector2(rand_range(0.5, 1.0) * Constants.FIELD_SIZE.x, rand_range(0.0,0.2) * Constants.FIELD_SIZE.y)
# warning-ignore:shadowed_variable
			var a = randf()*360.0
			for i in 5:
				var angle = a + i * 360 / 5 + 180/5
				var b = Bullets.create_bullet(p + Vector2(R2, 0).rotated(deg2rad(angle)), 0, angle, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREEN)
				Bullets.queue_update_bullet(b, 60+DELAY, null, null, null, 0.1)
			for i in 5:
				var angle = a + i * 360 / 5
				var b = Bullets.create_bullet(p + Vector2(R1, 0).rotated(deg2rad(angle)), 0, angle+180, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.RED )
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.1)
			for i in DENSITY:
				var angle = a + i * 360.0 / DENSITY
				var b = Bullets.create_bullet(p, 0, angle, 0.0, SPEED2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				Bullets.queue_update_bullet(b, 60+DELAY2, null, null, null, 0.1)
				b.layer = 1

			var b = Bullets.create_bullet(p, 0, 0.0, 0.0, 0.0, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.GREY)
			Bullets.queue_delete(b, 60+DELAY)
			b.layer = 1
				
		if u % RATE1 == RATE1/2:
			root.warning1.play()
			#var c = Constants.COLOURS_LARGE.RED if u % 24 == 0 else Constants.COLOURS_LARGE.GREY
# warning-ignore:shadowed_variable
			var a = randf()*360.0
# warning-ignore:shadowed_variable
			var p = Vector2(rand_range(0.0, 0.5) * Constants.FIELD_SIZE.x, rand_range(0.0,0.2) * Constants.FIELD_SIZE.y)
			for i in 5:
				var angle = a + i * 360 / 5 + 180/5
				var b = Bullets.create_bullet(p + Vector2(R2, 0).rotated(deg2rad(angle)), 0, angle, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREEN)
				Bullets.queue_update_bullet(b, 60+DELAY, null, null, null, 0.1)
			for i in 5:
				var angle = a + i * 360 / 5
				var b = Bullets.create_bullet(p + Vector2(R1, 0).rotated(deg2rad(angle)), 0, angle+180, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREY)
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.1)
			for i in DENSITY:
				var angle = a + i * 360.0 / DENSITY
				var b = Bullets.create_bullet(p, 0, angle, 0.0, SPEED2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.YELLOW)
				Bullets.queue_update_bullet(b, 60+DELAY2, null, null, null, 0.1)
				b.layer = 1

				
			var b = Bullets.create_bullet(p, 0, 0.0, 0.0, SPEED, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.YELLOW)
			Bullets.queue_delete(b, 60+DELAY)
			b.layer = 1
		if u % RATE2 == 0:
			#root.shoot1.play()
			#var c = Constants.COLOURS_LARGE.RED if u % 24 == 0 else Constants.COLOURS_LARGE.GREY
# warning-ignore:shadowed_variable
			var a = randf()*360.0
# warning-ignore:shadowed_variable
			var p = Vector2(rand_range(0.8, 1.0) * Constants.FIELD_SIZE.x, rand_range(0.2,1.0) * Constants.FIELD_SIZE.y)
			for i in 5:
				var angle = a + i * 360 / 5 + 180/5
				var b = Bullets.create_bullet(p + Vector2(R2, 0).rotated(deg2rad(angle)), 0, angle, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREEN)
				Bullets.queue_update_bullet(b, 60+DELAY, null, null, null, 0.1)
			for i in 5:
				var angle = a + i * 360 / 5
				var b = Bullets.create_bullet(p + Vector2(R1, 0).rotated(deg2rad(angle)), 0, angle+180, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.RED )
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.1)
			for i in DENSITY:
				var angle = a + i * 360.0 / DENSITY
				var b = Bullets.create_bullet(p, 0, angle, 0.0, SPEED2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				Bullets.queue_update_bullet(b, 60+DELAY2, null, null, null, 0.1)
				b.layer = 1

				
			var b = Bullets.create_bullet(p, 0, 0.0, 0.0, SPEED, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.GREY)
			Bullets.queue_delete(b, 60+DELAY)
			b.layer = 1
		if u % RATE2 == RATE2/2:
			#root.shoot1.play()
			#var c = Constants.COLOURS_LARGE.RED if u % 24 == 0 else Constants.COLOURS_LARGE.GREY
# warning-ignore:shadowed_variable
			var a = randf()*360.0
# warning-ignore:shadowed_variable
			var p = Vector2(rand_range(0.0, 0.2) * Constants.FIELD_SIZE.x, rand_range(0.2,1.0) * Constants.FIELD_SIZE.y)
			for i in 5:
				var angle = a + i * 360 / 5 + 180/5
				var b = Bullets.create_bullet(p + Vector2(R2, 0).rotated(deg2rad(angle)), 0, angle, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREEN)
				Bullets.queue_update_bullet(b, 60+DELAY, null, null, null, 0.1)
			for i in 5:
				var angle = a + i * 360 / 5
				var b = Bullets.create_bullet(p + Vector2(R1, 0).rotated(deg2rad(angle)), 0, angle+180, 0.0, SPEED, Constants.BULLET_TYPE.HEART, Constants.COLOURS_LARGE.GREY)
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.1)
			for i in DENSITY:
				var angle = a + i * 360.0 / DENSITY
				var b = Bullets.create_bullet(p, 0, angle, 0.0, SPEED2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.YELLOW)
				Bullets.queue_update_bullet(b, 60+DELAY2, null, null, null, 0.1)
				b.layer = 1

				
			var b = Bullets.create_bullet(p, 0, 0.0, 0.0, SPEED, Constants.BULLET_TYPE.MENTOS, Constants.COLOURS_LARGE.YELLOW)
			Bullets.queue_delete(b, 60+DELAY)
			b.layer = 1
				

func crossfire():
	var u = t - 180
	if u >= 0:
		if u % 6 == 0:
			var b = Bullets.create_bullet(Vector2(0, Constants.FIELD_SIZE.y * rand_range(0.0, 1.0)), rand_range(6,9), rand_range(-60, -15), 0.0, 0.0, Constants.BULLET_TYPE.ARROW, Constants.COLOURS_LARGE.BLUE)
			Bullets.set_gravity(b, Vector2(0, 0.1), Vector2(0, 100))
					
		if u % 6 == 3:
			var b = Bullets.create_bullet(Vector2(Constants.FIELD_SIZE.x, Constants.FIELD_SIZE.y * rand_range(0.0, 1.0)), rand_range(6,9), 180-rand_range(-60, -15), 0.0, 0.0, Constants.BULLET_TYPE.ARROW, Constants.COLOURS_LARGE.RED)
			Bullets.set_gravity(b, Vector2(0, 0.1), Vector2(0, 100))
			
			
func mike():
	#var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var COLOURS = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.ORANGE, Constants.COLOURS_LARGE.YELLOW, Constants.COLOURS_LARGE.GREEN, Constants.COLOURS_LARGE.CYAN, Constants.COLOURS_LARGE.BLUE, Constants.COLOURS_LARGE.PURPLE]
	
	var u = t - 180
	if u >= 0:
		if u % 1 == 0:
			var a = rad2deg(root.player.position.angle_to_point(position))
			var oset = rand_range(-1, 1) * 45
			var b = Bullets.create_bullet(position, 4 + (u % 7)*0.5, a + oset + 180, 0.0, 0.0, Constants.BULLET_TYPE.KNIFE, COLOURS[u % 7])
			var m = Vector2(120, 0).rotated(deg2rad(a))
			m.x += 666 if abs(a) < 90 else -666
			Bullets.set_gravity(b, Vector2(0.1, 0).rotated(deg2rad(a)), m)



func mandrill():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60 * 4
		if u % 6 == 0:
			var ACTIVE_TIME = 60 * 2
			if u % CYCLE_TIME < ACTIVE_TIME:
				root.shoot1.play()
				var DENSITY = 45
				var shift = 15 if u >= CYCLE_TIME else 45
				if u % CYCLE_TIME == 0:
					a = randf()*360.0
					lr *= -1
					p = root.player.position
				var r = (u % CYCLE_TIME) * 8
				var d = (p - position).normalized().rotated(deg2rad(-lr*shift))
				for i in DENSITY:
					Bullets.create_bullet(position + d*r, 3, a + i * 360.0 / DENSITY, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				a += lr * 5
		if u % CYCLE_TIME == 60 * 3:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
					
	if u % 10 == 0:
		if root.player.position.y < position.y:
			var offset = randf()*360.0
			for i in 30:
				Bullets.create_bullet(position, 5, offset + i * 12, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREY, true, 0.0, 0.0, BLEND_MODE_ADD)
		
func mandrill2():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60 * 6
		if u % 6 == 0:
			var ACTIVE_TIME = 60 * 2
			if u % CYCLE_TIME < ACTIVE_TIME:
				root.shoot1.play()
				var DENSITY = 20
				if u % CYCLE_TIME == 0:
					lr *= -1
					a = randf()*360.0
					a2 = randf()*360.0
					p = root.player.position
				var r = (u % CYCLE_TIME) * 8
				var d1 = (p - position).normalized().rotated(deg2rad(-45))
				var d2 = (p - position).normalized().rotated(deg2rad(45))
				for i in DENSITY:
					Bullets.create_bullet(position + d1*r, 3, a + i * 360.0 / DENSITY, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
					Bullets.create_bullet(position + d2*r, 3, a2 + i * 360.0 / DENSITY, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				a +=  7 * lr
				a2 += 7 * lr
		if u % CYCLE_TIME == 60 * 3:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
		
	if u % 10 == 0:
		if root.player.position.y < position.y:
			var offset = randf()*360.0
			for i in 30:
				Bullets.create_bullet(position, 5, offset + i * 12, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREY, true, 0.0, 0.0, BLEND_MODE_ADD)
			
func mandrill3():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = int( 60 * 5.5)
		if u % 5 == 0:
			var ACTIVE_TIME = 60 * 3
			if u % CYCLE_TIME < ACTIVE_TIME:
				root.shoot1.play()
				var DENSITY = 45
				if u % CYCLE_TIME == 0:
					a = randf()*360.0
					lr *= -1
					p = Vector2(0, Constants.FIELD_SIZE.y * 0.8)
					if lr == 1:
						p.x = Constants.FIELD_SIZE.x
				var r = (u % CYCLE_TIME) * 6
				var d = (p - position).normalized()
				for i in DENSITY:
					Bullets.create_bullet(position + d*r, 3, a + i * 360.0 / DENSITY, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				#a = randf()*360.0
				a += lr * (1.61803398875 + rand_range(-0.3, 0.3)) * 180.0 / DENSITY
		if u % CYCLE_TIME == 60 * 3:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
					

func mandrill4():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60 * 8
		if u % 1 == 0:
			var ACTIVE_TIME = 60 * 6
			if u % CYCLE_TIME < ACTIVE_TIME:
				root.shoot1.play()
				var DENSITY = 2
				var shift = 0
				Bullets.create_bullet(Vector2(position.x, -60), 4, 90 + 30 * sin(a2), 0.0, 0.0, Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.GREY)
				Bullets.create_bullet(Vector2(position.x, -60), 4, 90 + 30 * sin(a2+TAU/3), 0.0, 0.0, Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.GREY)
				Bullets.create_bullet(Vector2(position.x, -60), 4, 90 + 30 * sin(a2+2*TAU/3), 0.0, 0.0, Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.GREY)
				#Bullets.create_bullet(Vector2(position.x, 0), 3, 90 - 30 * sin(a2), 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.GREY)
				a2 += lr * 1.61803398875*PI/20
		if u % CYCLE_TIME == 60 * 7:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y)
						
		if u % 10 == 0:
			var a = rad2deg(root.player.position.angle_to_point(position))
			if abs(a-90)>36.0:
				var offset = randf()*360.0
				for i in 30:
					Bullets.create_bullet(position, 5, offset + i * 12, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.GREY, true, 0.0, 0.0, BLEND_MODE_ADD)


func futo():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60*4
		var ATTACK_TIME = 60*2.5
		var ATTACK_TIME2 = 60*3.5
		
		if u % CYCLE_TIME == 0:
			lr *= -1
			a = randf()*360.0
			a2 = 1.5
		if u % CYCLE_TIME < ATTACK_TIME:
			if u % 12 == 0:
				a += a2
				a2 += 0.76735 * lr
				for i in 120:
					var b = Bullets.create_bullet(position + Vector2(0, -100), 8, a + i * 360 / 120.0, -0.08, 1.5, Constants.BULLET_TYPE.ARROW, Constants.COLOURS_LARGE.BLUE)
					Bullets.queue_update_bullet(b, 90, null, null, null, 0.1, 4.0, null, Constants.COLOURS_LARGE.RED)

		elif u % CYCLE_TIME < ATTACK_TIME2:
			if u % 12 == 0:
				a += 180/120.0
				for i in 120:
					var b = Bullets.create_bullet(position + Vector2(0, -100), 8, a + i * 360 / 120.0, -0.08, 1.5, Constants.BULLET_TYPE.ARROW, Constants.COLOURS_LARGE.BLUE)
					Bullets.queue_update_bullet(b, 90, null, null, null, 0.1, 4.0, null, Constants.COLOURS_LARGE.RED)


func fake_guze():
	var COLOURS = [Constants.COLOURS_DIVINE_SPIRIT.GREEN, Constants.COLOURS_DIVINE_SPIRIT.CYAN]
	var COLOURS2 = [Constants.COLOURS_DIVINE_SPIRIT.PURPLE, Constants.COLOURS_DIVINE_SPIRIT.YELLOW]
	var u = t - 180
	if u >= 0:
		if u == 0:
			a = 90
			a2 = 90 + 180/7.0
		for i in 1:
			a += 367.27/7
			a2 -= 367.27/7
			Bullets.create_bullet(position - Vector2(0, 50), 0.0, a, 0.2, 12.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, COLOURS[(u) % 2], true, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.create_bullet(position - Vector2(0, 50), 0.0, a2, 0.2, 12.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, COLOURS2[(u) % 2], true, 0.0, 0.0, BLEND_MODE_ADD)

func overflow():
	var COLOURS = [Constants.COLOURS_DIVINE_SPIRIT.RED, Constants.COLOURS_DIVINE_SPIRIT.ORANGE, Constants.COLOURS_DIVINE_SPIRIT.YELLOW, Constants.COLOURS_DIVINE_SPIRIT.GREEN, Constants.COLOURS_DIVINE_SPIRIT.CYAN, Constants.COLOURS_DIVINE_SPIRIT.BLUE, Constants.COLOURS_DIVINE_SPIRIT.PURPLE]
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60*8
		var ATTACK_TIME = 60*7
		
		if u % CYCLE_TIME == 0:
			a = randf()*360.0
			lr *= -1
			
		
		if u % CYCLE_TIME < ATTACK_TIME && u % 4 == 0:
			var speed = min(3.0 + 12 * (u % CYCLE_TIME)/float(ATTACK_TIME), 15.0)
			a += 4.0 * lr
			for i in 9:
				var colour = COLOURS[randi()%7]
				Bullets.create_bullet(position, speed + rand_range(-1, 1), a + i * 360 / 9 + rand_range(-5, 5), 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, colour, true, 0.0, 0.0, BLEND_MODE_ADD)
			
			
			
func clownnon():
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60*8
		var ATTACK_TIME = int( 60*6.5)
		if u % CYCLE_TIME < 5*13 && (u % CYCLE_TIME) % 5 == 0:
			var order = (u % CYCLE_TIME) / 5
			Bullets.create_straight_laser(position - Vector2(520-order*40, 380-order*10), 90, 1200, 36, 30, int(300-(u % CYCLE_TIME)*0.5), Constants.BULLET_TYPE.LEGACY_LASER, Constants.COLOURS.RED, 0.0, BLEND_MODE_ADD)
			Bullets.create_straight_laser(position - Vector2(-520+order*40, 380-order*10), 90, 1200, 36, 30, int(300-(u % CYCLE_TIME)*0.5), Constants.BULLET_TYPE.LEGACY_LASER, Constants.COLOURS.RED, 0.0, BLEND_MODE_ADD)

		if u % CYCLE_TIME < (ATTACK_TIME - 60) && u % 1 == 0:
			Bullets.create_bullet(position, 13, rad2deg(root.player.position.angle_to_point(position)) + 36 * sin(a), 0.0, 0.0, Constants.BULLET_TYPE.STAR_LARGE, Constants.COLOURS_LARGE.BLUE, true, 0.0, 6)
			a += lr * 1.61803398875*PI/25
		if u % CYCLE_TIME == ATTACK_TIME:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.2, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y) 
		
		
		
		
func megumu():
	var TURN = 6
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.PURPLE, Constants.COLOURS.BLUE, Constants.COLOURS.CYAN, Constants.COLOURS.GREEN]
	var COLOURS2 = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.PURPLE, Constants.COLOURS_LARGE.BLUE, Constants.COLOURS_LARGE.CYAN, Constants.COLOURS_LARGE.GREEN]
	var u = t - 180
	if u >= 0:
		var CYCLE_TIME = 60*4
		var ATTACK_TIME = 60*3
		var ATTACK_TIME2 = 60*3
		if u % CYCLE_TIME == 0:
			a = randf()*360.0
			a2 = a
			lr *= -1
		if u % CYCLE_TIME < (ATTACK_TIME - 60) && (u % CYCLE_TIME) % 3 == 0:
			root.laser1.play()
			var r = (u % CYCLE_TIME) * 8
			
			for i in 5:
				var o = i * 360 / 5
				Bullets.create_straight_laser(position + Vector2(r,0).rotated(deg2rad(o + a)), a + o - lr*120, 1500, 32, 90, 120, Constants.BULLET_TYPE.LEGACY_LASER, COLOURS[i], 0.0, BLEND_MODE_ADD)
			
			
			a += TURN * lr
			a2 += TURN * 2
		if u % CYCLE_TIME == ATTACK_TIME2:
			root.shoot1.play()
			root.warning1.play()
			var o = randf()*360.0
			for i in 90:
				Bullets.create_bullet(position, 4, o + lr * i * 4, 0.0, 0.0, Constants.BULLET_TYPE.STAR_LARGE, COLOURS2[i%5], true, 0.0, 6 * lr)
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.25, 0.4) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y) 
			
		
		
func gears_of_war():
	var DENSITY = 10
	var DENSITY2 = 70
	var u = t - 180
	if u >= 0:
		if u % 45 == 0:
			lr *= -1
			var o = randf()
			var a = 90 + 0*rand_range(-1, 1)
			for i in DENSITY:
				var b = Bullets.create_bullet(Vector2(Constants.FIELD_SIZE.x * (i-o-1) / (DENSITY-3), -64), 25.0, a, -1, 3.0, Constants.BULLET_TYPE.GEAR, Constants.COLOURS_SAW.BLOOD, true, 0.0, lr*0.05)
				if lr == 1:
					b.sprite_angle += deg2rad(180 / 12.0)
				lr *= -1
		if u % 180 == 180:
			var o = randf() * 360.0
			for i in DENSITY2:
				var b = Bullets.create_bullet(position, 12.0, o + i * 360.0 / DENSITY2, -1, 5.0, Constants.BULLET_TYPE.SAW_SMALL, Constants.COLOURS_SAW.NORMAL, true, 0.0, lr*0.1)
				b.bounce_count = 2
				b.layer = 1
				if lr == 1:
					b.sprite_angle += deg2rad(180 / 12.0)
				lr *= -1
		if u % 180 == 60:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.2, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y) 
			
func warsaw():
	var DENSITY = 30
	var DENSITY2 = 60
	var u = t - 60
	if u >= 0:
		if u % 60 == 0:
			root.shoot1.play()
			lr *= -1
			var o = randf() * 360.0
			for i in DENSITY:
				var b = Bullets.create_bullet(position, 15.0, o + i * 360.0 / DENSITY, -0.5, 3.0, Constants.BULLET_TYPE.SAW, Constants.COLOURS_SAW.BLOOD, true, 0.0, lr*2)
				if lr == 1:
					b.sprite_angle = randf()*360.0
				lr *= -1
		if u % 180 == 75:
			root.shoot1.play()
			var o = randf() * 360.0
			for i in DENSITY2:
				var b = Bullets.create_bullet(position, 12.0, o + i * 360.0 / DENSITY2, -1, 5.0, Constants.BULLET_TYPE.SAW_SMALL, Constants.COLOURS_SAW.BLOOD, true, 0.0, lr*3)
				b.bounce_count = 2
				b.layer = 1
				if lr == 1:
					b.sprite_angle = randf()*360.0
				lr *= -1
		if u % 180 == 90:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range(0.2, 0.35) * Constants.FIELD_SIZE.y
			dest = Vector2(x, y) 
		

func backstab():
	var COLOURS = [Constants.COLOURS_DIVINE_SPIRIT.RED, Constants.COLOURS_DIVINE_SPIRIT.ORANGE, Constants.COLOURS_DIVINE_SPIRIT.YELLOW, Constants.COLOURS_DIVINE_SPIRIT.GREEN, Constants.COLOURS_DIVINE_SPIRIT.CYAN, Constants.COLOURS_DIVINE_SPIRIT.BLUE, Constants.COLOURS_DIVINE_SPIRIT.PURPLE]
	var COLOURS2 = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.ORANGE, Constants.COLOURS_LARGE.YELLOW, Constants.COLOURS_LARGE.GREEN, Constants.COLOURS_LARGE.CYAN, Constants.COLOURS_LARGE.BLUE, Constants.COLOURS_LARGE.PURPLE]
	var u = t - 180
	if u >= 0:
		if u % 1 == 0:
			a += 137.5077640500378546463487
			Bullets.create_bullet(position, 4, a, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, COLOURS[randi()%7], true, 0.0, 0.0, BLEND_MODE_ADD)
		if u > 360 && u % 20 == 0:
			var p = Vector2((root.player.position.x - Constants.FIELD_SIZE.x * 0.5) * 0.5 + Constants.FIELD_SIZE.x * 0.5 + lr * rand_range(0.0, 0.1) * Constants.FIELD_SIZE.x, Constants.FIELD_SIZE.y + 64)
			Bullets.create_bullet(p, 1.5, ["at player", lr * max(0, 45 + (360 - u) * 0.1)], 0.0, 0.0, Constants.BULLET_TYPE.KNIFE, 0)
		if u > 180 && u % 20 == 10:
			var a = root.player.position.angle_to_point(position + Vector2(0, Constants.FIELD_SIZE.y))
			var f = -1/sin(a)
			Bullets.create_bullet(position, 12 *f, rad2deg(a) + rand_range(-20, 20) + rand_range(-1, 1) * max(0, 45 + (180 - u) * 0.1), -0.3 * f, 1.5 * f, Constants.BULLET_TYPE.KNIFE, 0)
			lr *= -1

	

func losemoney():
	var u = t - 180
	if u >= 0:
		if u % 2 == 0:
			var p = root.player.position + Vector2(0, 32) + Vector2(rand_range(0, 16),0).rotated(randf()*TAU)
			var angle = rand_range(60, 120)
			var s = Constants.FIELD_SIZE.y - p.y - 64
			var travel_time: int
			var disc_squared = 15*15 + 2 * -0.25 * s
			if disc_squared >= 0:
				travel_time = int((-15 + sqrt(disc_squared)) * -4 / sin(deg2rad(angle)))
			else:
				travel_time = int(52 + (s - 442) * 0.5 / sin(deg2rad(angle)))
			#print(travel_time)
			
			#int((p.y + 32) * sin(deg2rad(angle)) * 0.5)
			var b = Bullets.create_bullet(p, 15, angle, -0.25, 2.0, Constants.BULLET_TYPE.COIN, Constants.COLOURS_COIN.SILVER, true, 0.0, lr * 0.1)
			Bullets.queue_update_bullet(b, travel_time, null, null,null, 0.5, 8)
			Bullets.queue_update_bullet(b, travel_time + 60, null, null, "at player")
			b.warp_count = 1
			b.warp_bottom = true
			
		if u % 2 == 1:
			lr *= -1
			var p = root.player.position + Vector2(0, 16) + Vector2(rand_range(0, 16),0).rotated(randf()*TAU)
			var angle = rand_range(60, 120)
			var s = Constants.FIELD_SIZE.y - p.y - 64
			var travel_time: int
			var disc_squared = 15*15 + 2 * -0.25 * s
			if disc_squared >= 0:
				travel_time = int((-15 + sqrt(disc_squared)) * -4 / sin(deg2rad(angle)))
			else:
				travel_time = int((s - 442) * 0.5 / sin(deg2rad(angle)))
			
			#int((p.y + 32) * sin(deg2rad(angle)) * 0.5)
			var b = Bullets.create_bullet(p, 15, angle, -0.25, 2.0, Constants.BULLET_TYPE.COIN, Constants.COLOURS_COIN.GOLD, true, 0.0, lr * 0.1)
			Bullets.queue_update_bullet(b, travel_time, null, null,null, 0.5, 8)
			Bullets.queue_update_bullet(b, travel_time+60, null, null, "at player")
			b.warp_count = 1
			b.warp_bottom = true



func lasagnacode():
	var u = t - 180
	if u >= 0:
		if u % 40 == 0:
			var s = max(27 - u * 0.005, 12)
			var DENSITY = int(s*2.25+5)
			var n = 9 if u >= 3000 else int(min(1+u * 0.00175, 6))
			var s2 = min(1 + u * 0.0004, 3)
			var angle = randf()*360.0
			var offset = rand_range(-10, 10)
			for i in DENSITY:
				if n % 2 == 1:
					for j in (n-1)/2:
						var o = (j + 1)*4
						var b1 = Bullets.create_bullet(position, s, angle + i * 360.0 / DENSITY, -0.55, s2, Constants.BULLET_TYPE.SNOWBALL, Constants.COLOURS.ORANGE - (u/40) % 2)
						Bullets.queue_update_bullet(b1, 50, null, null,  angle + i * 360.0 / DENSITY + offset + o, 0.1*s2, s2 * rand_range(0.667, 1.5), Constants.BULLET_TYPE.BALL)
						var b2 = Bullets.create_bullet(position, s, angle + i * 360.0 / DENSITY, -0.55, s2, Constants.BULLET_TYPE.SNOWBALL, Constants.COLOURS.ORANGE - (u/40) % 2)
						Bullets.queue_update_bullet(b2, 50, null, null,  angle + i * 360.0 / DENSITY + offset - o, 0.1*s2, s2 * rand_range(0.667, 1.5), Constants.BULLET_TYPE.BALL)
					var b = Bullets.create_bullet(position, s, angle + i * 360.0 / DENSITY, -0.55, s2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.ORANGE - (u/40) % 2)
					Bullets.queue_update_bullet(b, 50, null, null,  angle + i * 360.0 / DENSITY + offset, 0.1*s2, s2 * rand_range(0.667, 1.5))
					#print(b.transform_queue)

				else:
					for j in n/2:
						var o = (j + 0.5)*4
						var b1 = Bullets.create_bullet(position, s, angle + i * 360.0 / DENSITY, -0.55, s2, Constants.BULLET_TYPE.SNOWBALL, Constants.COLOURS.ORANGE - (u/40) % 2)
						Bullets.queue_update_bullet(b1, 50, null, null,  angle + i * 360.0 / DENSITY + offset + o, 0.1*s2, s2 * rand_range(0.667, 1.5), Constants.BULLET_TYPE.BALL)
						var b2 = Bullets.create_bullet(position, s, angle + i * 360.0 / DENSITY, -0.55, s2, Constants.BULLET_TYPE.BALL, Constants.COLOURS.ORANGE - (u/40) % 2)
						Bullets.queue_update_bullet(b2, 50, null, null,  angle + i * 360.0 / DENSITY + offset - o, 0.1*s2, s2 * rand_range(0.667, 1.5), Constants.BULLET_TYPE.BALL)

func flick():
	var DENSITY = 30
	var DENSITY2 = 10
	var MIN_SPEED = 2
	var SPEED_STEP = 0.75
	var ANGLE_STEP = 1.5
	var u = t - 180
	if u >= 0:
		if u % 60 == 0:
			lr *= -1
			var offset = randf()*360.0
			for i in DENSITY:
				for j in DENSITY2:
					Bullets.create_bullet(position, MIN_SPEED + j * SPEED_STEP, offset + i * 360.0 / DENSITY + lr * j * ANGLE_STEP, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)


func himemushi():
	var DENSITY = 5
	var DECEL = 0.2
	var SKEW = 4.0
	var u = t - 120
	if u >= 0:
		a += 2.61803398875
		if u % 2 == 0:
			root.shoot1.play()
			for i in DENSITY:
				var angle = 90.0 + lr*a + i * 360.0 / DENSITY
				var b = Bullets.create_bullet(position, 10.0, angle, 0.0, 1.5, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.PURPLE)
				Bullets.queue_update_bullet(b, 20, null, null, null, null, null, null, null, null, lr*SKEW)
				Bullets.queue_update_bullet(b, 36, null, null, null, -DECEL, null, null, null, null, 0.0)
				angle = 90.0 - lr*a + i * 360.0 / DENSITY
				b = Bullets.create_bullet(position, 10.0, angle, 0.0, 1.5, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.PURPLE)
				Bullets.queue_update_bullet(b, 20, null, null, null, null, null, null, null, null, -lr*SKEW)
				Bullets.queue_update_bullet(b, 36, null, null, null, -DECEL, null, null, null, null, 0.0)
		if u % 180 == 160:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = (0.25 - lr * 0.05) * Constants.FIELD_SIZE.y
			weight = 60
			dest = Vector2(x, y) 
			lr *= -1
		

func yoshika():
	var u = t - 180
	if u >= 0:
		pass


var eyes = []

func wrasse ():
	var CYCLE_TIME = 210
	
	var u = t - 120
	if u >= 0:
		if u == 0:
			dest = Vector2(500, 200)
			a2 = 48
			a3 = 60
			a4 = 3.0
			Bullets.create_straight_laser(Vector2(-100, 500), 0, 1200, 16, 999999999, 10, Constants.BULLET_TYPE.LEGACY_LASER, Constants.COLOURS.WHITE, 0.0, BLEND_MODE_ADD)
		if u % CYCLE_TIME == 0:
			root.shoot1.play()
			lr *= -1
			a = randf()
			a2 = min(a2 + 1, 52)
			a3 = min(a3 + 2, 90)
			a4 = min(a4 + 2.5, 12.0)
			
			eyes.clear()
			
			var b1 = Bullets.create_bullet(Vector2(200 - (a - 0.5) * 200, 500 + lr * 1000), 12.0, -lr * 90, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.BLUE_D)
			var b2 = Bullets.create_bullet(Vector2(800 - (a - 0.5) * 200, 500 + lr * 1000), 12.0, -lr * 90, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.BLUE_D)
			Bullets.set_autodelete(b1, false)
			Bullets.set_autodelete(b2, false)
			Bullets.queue_autodelete(b1, 90, true)
			Bullets.queue_autodelete(b2, 90, true)
			Bullets.queue_update_bullet(b1, a2 - (u % CYCLE_TIME), null, null, null, - 2)
			Bullets.queue_update_bullet(b2, a2 -  (u % CYCLE_TIME), null, null, null, - 2)
			Bullets.queue_update_bullet(b1, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
			Bullets.queue_update_bullet(b2, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
			
			eyes.append(b1)
			eyes.append(b2)
			
		if u % CYCLE_TIME < 21 && u % 2 == 0:
			var delta = (u % CYCLE_TIME) * 5.0
			var delta2 = (21 - (u % CYCLE_TIME)) * 5.0
			for i in 7:
				for j in 2:
					var type = Constants.BULLET_TYPE.ICE if ((u % CYCLE_TIME > 0 && u % CYCLE_TIME < 20) || j == 1) else Constants.BULLET_TYPE.ICE_LARGE
					var col = Constants.COLOURS.WHITE if ((u % CYCLE_TIME > 0 && u % CYCLE_TIME < 20) || j == 1) else Constants.COLOURS_LARGE.GREY
					var col2 = Constants.COLOURS.GREEN if ((u % CYCLE_TIME > 0 && u % CYCLE_TIME < 20) || j == 1) else Constants.COLOURS_LARGE.GREEN
					var dy = 0# if ((u % CYCLE_TIME > 0 && u % CYCLE_TIME < 20) || j == 1) else 26 * lr
					if j == 0:
						if  u % CYCLE_TIME == 0:
							dy = 26 * lr
						elif u % CYCLE_TIME >= 20:
							dy = -18 * lr
					var b1 = Bullets.create_bullet(Vector2(1000 * (i - a) / 5.0 + delta, 500 - lr * (550 + j * 80 + delta2) - dy), 12.0, lr * 90, 0.0, 0.0, type, col if randi()%8 != 0 else col2)
					var b2 = Bullets.create_bullet(Vector2(1000 * (i - a) / 5.0 - delta, 500 - lr * (550 + j * 80 + delta2) - dy), 12.0, lr * 90, 0.0, 0.0, type, col if randi()%8 != 0 else col2)
					var b3 = Bullets.create_bullet(Vector2(1000 * ((i - a)-0.5) / 5.0 + delta, 500 + lr * (550 + j * 80 + delta2) + dy), 12.0, -lr * 90, 0.0, 0.0, type, col if randi()%8 != 0 else col2)
					var b4 = Bullets.create_bullet(Vector2(1000 * ((i - a)-0.5) / 5.0 - delta, 500 + lr * (550 + j * 80 + delta2) + dy), 12.0, -lr * 90, 0.0, 0.0, type, col if randi()%8 != 0 else col2)
					Bullets.queue_update_bullet(b1, Constants.TRANSFORM_COND.GRAZE, null, null, null, null, null, null, col)
					Bullets.queue_update_bullet(b2, Constants.TRANSFORM_COND.GRAZE, null, null, null, null, null, null, col)
					Bullets.queue_update_bullet(b3, Constants.TRANSFORM_COND.GRAZE, null, null, null, null, null, null, col)
					Bullets.queue_update_bullet(b4, Constants.TRANSFORM_COND.GRAZE, null, null, null, null, null, null, col)
					
					Bullets.set_autodelete(b1, false)
					Bullets.set_autodelete(b2, false)
					Bullets.set_autodelete(b3, false)
					Bullets.set_autodelete(b4, false)
					if b1: b1.layer = 0 if (u % CYCLE_TIME > 0 || j == 1) else 1
					if b2: b2.layer = 0 if (u % CYCLE_TIME > 0 || j == 1) else 1
					if b3: b3.layer = 0 if (u % CYCLE_TIME > 0 || j == 1) else 1
					if b4: b4.layer = 0 if (u % CYCLE_TIME > 0 || j == 1) else 1
					
					Bullets.queue_autodelete(b1, 20, true)
					Bullets.queue_autodelete(b2, 20, true)
					Bullets.queue_autodelete(b3, 20, true)
					Bullets.queue_autodelete(b4, 20, true)
					
					Bullets.queue_update_bullet(b1, a2 - (u % CYCLE_TIME), null, null, null, - 2)
					Bullets.queue_update_bullet(b2, a2 - (u % CYCLE_TIME), null, null, null, - 2)
					Bullets.queue_update_bullet(b3, a2 - (u % CYCLE_TIME), null, null, null, - 2)
					Bullets.queue_update_bullet(b4, a2 - (u % CYCLE_TIME), null, null, null, - 2)
					
					Bullets.queue_update_bullet(b1, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
					Bullets.queue_update_bullet(b2, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
					Bullets.queue_update_bullet(b3, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
					Bullets.queue_update_bullet(b4, 150 - (u % CYCLE_TIME), null, null, null, null, -8.0)
		if u % CYCLE_TIME == a2:
			$chomp.play()
		if u % CYCLE_TIME == 60:
			#Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)), 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
			Bullets.create_straight_laser(eyes[0].position, rad2deg(root.player.position.angle_to_point(p)), 0.0, 192.0, a3, 1, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, 0.0, BLEND_MODE_ADD)
			p = Vector2(825 - (a - 0.5) * 200, 500 + 300 * lr)
			Bullets.create_straight_laser(eyes[1].position, rad2deg(root.player.position.angle_to_point(p)), 0.0, 192.0, a3, 1, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, 0.0, BLEND_MODE_ADD)
			#Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)), 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
	
		if u % CYCLE_TIME >= 60 && u % CYCLE_TIME < 60 + a3 && u % 6 == 0:
			root.warning1.play()
			var p = eyes[0].position
			var b = Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)), 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
			if b: b.layer = 1
			#Bullets.create_loose_laser(p, a4, rad2deg(root.player.position.angle_to_point(p)), 360.0, 32.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			p = eyes[1].position
			b = Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)), 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
			b.layer = 1
			#Bullets.create_loose_laser(p, a4, rad2deg(root.player.position.angle_to_point(p)), 360.0, 32.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			
			
			for i in range(1, 4):
				for j in 2:
					var rl = j * 2 - 1
					p = eyes[0].position
					b = Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)) + rl * i * 24, 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
					if b: b.layer = 1
					#Bullets.create_loose_laser(p, a4, rad2deg(root.player.position.angle_to_point(p)) + rl * i * 24, 360.0, 32.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
					p = eyes[1].position
					b = Bullets.create_bullet(p, a4, rad2deg(root.player.position.angle_to_point(p)) + rl * i * 24, 0.0, 0.0, Constants.BULLET_TYPE.BULLET, Constants.COLOURS.BLUE)
					b.layer = 1
					#Bullets.create_loose_laser(p, a4, rad2deg(root.player.position.angle_to_point(p)) + rl * i * 24, 360.0, 32.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
					
			
		if u % 15 == 150:
			for _i in 1:
				var delta = (u % CYCLE_TIME) * 6.0
				for i in 6:
					Bullets.create_bullet(Vector2(500 + lr * (520 - delta), 1000 * i / 5.0), 2.0, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.WHITE)
					Bullets.create_bullet(Vector2(500 - lr * (520 - delta), 1000 * (i-0.5) / 5.0), 2.0, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.WHITE)
			
			
func tss():
	var density = 90
	if t % 30 == 0:
		root.shoot1.play()
		for i in density:
			Bullets.create_bullet(position, 2.5, i * 360.0 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, -0.0, 0.0, BLEND_MODE_ADD)
	if t % 30 == 20:
		root.shoot1.play()
		var o = randf() * 360.0
		for i in density:
			Bullets.create_bullet(position, 2.5, (i + 0.5) * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)

func tss2():
	var density = 90
	var u = t - 60
	if u >= 0:
		if u % 300 == 0:
			lr *= -1
		if u % 300 < 210:
			if u % 30 == 0:
				a += lr
				root.shoot1.play()
				for i in density:
					Bullets.create_bullet(position, 2.5, a + i * 360.0 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, -lr*0.2, 0.0, BLEND_MODE_ADD)
			if u % 30 == 15:
				a += lr
				root.shoot1.play()
				var o = randf() * 360.0
				for i in density:
					Bullets.create_bullet(position, 2.5, a + (i + 0.5) * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, lr*0.2, 0.0, BLEND_MODE_ADD)
			
func waterdance():
	var u = t - 120
	if u >= 0:
		var aim = sin(u * 0.02) * 24
		
		if u % 4 == 0:
			for i in range(-5, 6):
				var angle = aim + i * 8 - 90 + rand_range(-5, 5) * 0
				var b = Bullets.create_bullet(position, rand_range(10,10.5), angle, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.set_gravity(b, Vector2(0, 0.2), Vector2(0, 10))

func super_laser_piss():
	var u = t - 120
	if u >= 0:
		if u == 0:
			a = 6
		if u % 320 == 0:
			a2 = 90# + randf()*360.0
			lr *= -1
		if u % 320 < 240 && u % 40 < 18:
			if u % 3 == 0:
				root.shoot1.play()
				var w = u * 0.1
				var r = min(u, 128)
				var angle = a2#rad2deg(root.player.position.angle_to_point(position)) + rand_range(-5, 5)*0
				#a = min(a + 0.005, 6)
				for i in 19:
					var speed = a#min(a*0.05 + 10, 20)
					var b = Bullets.create_bullet(position, speed, angle + i * 360.0 / 19.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
					if b:
						b.bounce_count = 1
						b.bounce_top = true
						b.bounce_bottom = false
					Bullets.queue_set_gravity(b, Constants.TRANSFORM_COND.BOUNCE, Vector2(0, 0.05), Vector2(0, 16))
					#Bullets.queue_update_bullet(b, Constants.TRANSFORM_COND.BOUNCE, null, 100)
		a2 += 0.3 * lr
	
func current():
	var u = t - 60
	if u >= 0:
		for _i in 3:
			Bullets.create_bullet(Vector2(rand_range(-20, 450), -20), rand_range(4, 8), 90, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.create_bullet(Vector2(rand_range(550, 1020), 1020), rand_range(4, 8), -90, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
		if u % 45 == 0:
			for _i in 1:
				Bullets.create_bullet(Vector2(rand_range(450, 500), -20), 5, 90, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.create_bullet(Vector2(rand_range(500, 550), 1020), 5, -90, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)


func shapeattack():
	var u = t - 120
	if u >= 0:
		if u % 30 == 0:
			root.shoot1.play()
			var pos = position
			var speed = 4.75
			var offset = a
			var sides = 3
			var density = 29
			
			var sidestep = 360.0 / sides

			for i in sides:
				for j in density:
					Bullets.create_bullet(pos, speed / cos(deg2rad((j - density * 0.5) * sidestep / density)), offset + i * sidestep + j * sidestep / density, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
			if (a >= 180 && lr == 1) || (a <= 0 && lr == -1):
				lr *= -1
			
			a += 30 * lr
			
		if (u + 1) % 300 == 30000:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			dest = Vector2(x, position.y	)

func shapeattack2():
	var u = t - 120
	if u >= 0:
		if u % 20 == 0:
			root.shoot1.play()
			var pos = position
			var speed = 6
			var offset = a - 90
			var sides = 5
			var density = 16
			
			var sidestep = 360.0 / sides

			for i in sides:
				for j in density:
					Bullets.create_bullet(pos, speed / cos(deg2rad((j - density * 0.5) * sidestep / density)), offset + i * sidestep + j * sidestep / density, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
			if (a >= 180 && lr == 1) || (a <= 0 && lr == -1):
				lr *= -1
			
			a += 15 * lr
			
		if (u + 1) % 300 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			dest = Vector2(x, position.y	)

func shapeattack3():
	var u = t - 120
	if u >= 0:
		if u == 0:
			a = 0
		if u % 18 == 0:
			root.shoot1.play()
			var pos = position
			var speed = 6
			var offset = a# + randf()*360.0
			a -= 16
			var sides = 3 + int(a2) % 6
			a2 += 1
			var density = 72 / sides
			
			var sidestep = 360.0 / sides

			for i in sides:
				for j in density:
					Bullets.create_bullet(pos, speed / cos(deg2rad((j - density * 0.5) * sidestep / density)), offset + i * sidestep + j * sidestep / density, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)

		if (u + 1) % 300 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			dest = Vector2(x, position.y)

func shapeattack4():
	var u = t - 120
	if u >= 0:
		if u == 0:
			a = -90
		if u % 18 == 0:
			root.shoot1.play()
			var pos = position
			var speed = 4
			var offset = a# + randf()*360.0
			a -= 14
			var sides = 1
			a2 += 1
			var density = 90
			
			var sidestep = 360.0

			for j in density:
				Bullets.create_bullet(pos, speed / (cos(deg2rad( 180 * (j - density * 0.5) / density))), offset + j * 360.0 / density, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)

		if (u + 1) % 300 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			dest = Vector2(x, position.y)

func firesaber():
	var u = t - 120
	var difficulty = 3
	var densities = [2 if u % 3 == 0 else 1, 2, 2, 3]
	var max_speeds = [4.0, 4.0, 6.0, 6.0]
	var sp_range = [90, 90, 120, 150]
	var CYCLE_TIME = [420, 420, 330, 360]#360 if difficulty >= 2 else 420#240
	if u >= 0:
		if u % CYCLE_TIME[difficulty] == 0:
			root.laser1.play()
			a = 90 + 45 * lr
			Bullets.create_straight_laser(position, a, 866, 160, 0.0, 170, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, lr * 2, BLEND_MODE_ADD)
			Bullets.create_straight_laser(position, a, 866, 120, 0.0, 170, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.RED, lr * 2, BLEND_MODE_ADD)
			Bullets.create_straight_laser(position, a, 866, 120, 0.0, 170, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.ORANGE, lr * 2, BLEND_MODE_ADD)
			lr *= -1
		if u % CYCLE_TIME[difficulty] < 170:
			root.shoot1.play()
			a -= lr * 2
			for _i in densities[difficulty]:
				var r = rand_range(-100, 800)
				var pos = position + Vector2(r, 0).rotated(deg2rad(a))
				var s = rand_range(1.5, max_speeds[difficulty])
				var c = Constants.COLOURS_LARGE.RED if randi()%4 != 0 else Constants.COLOURS_LARGE.ORANGE
				var b = Bullets.create_bullet(pos, 0.25, a - 90 * lr + rand_range(-1, 1) * sp_range[difficulty], 0.0, s, Constants.BULLET_TYPE.FIREBALL, c, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.queue_update_bullet(b, 120, null, null, null, 0.025)
				

func firesaber2():
	var u = t - 120
	var CYCLE_TIME = 360
	
	if u >= 0:
		if u % CYCLE_TIME == 0:
			a2 = randf()
			root.laser1.play()
			a = 90 + 45 * lr
			Bullets.create_straight_laser(position, a, 866, 120, 0.0, 210, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.RED, lr * 1.61803398875, BLEND_MODE_ADD)
			lr *= -1
		if u % CYCLE_TIME < 210 && u % 3 == 0:
			root.shoot1.play()
			a -= lr * 1.61803398875 * 3
			for i in 9:
				var r = (i + (u % 3)/30.0 + a2) * 100#rand_range(-100, 900)
				var pos = position + Vector2(r, 0).rotated(deg2rad(a))
				var s = 4#rand_range(2.0, 6.0)
				var b = Bullets.create_bullet(pos, 0.25, a - 180 * lr + rand_range(-1, 1) * 0, 0.0, s, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.set_autodelete(b, false)
				Bullets.queue_update_bullet(b, 120, null, null, null, 0.025)
				Bullets.queue_autodelete(b, 240, true)
				
		if u % CYCLE_TIME == 18000:
			var o = randf()*360.0
			for i in 60:
				var b = Bullets.create_bullet(position, 6, i*6.0 + o, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.queue_delete(b, 60)
				

func incinerate():
	var u = t - 120
	if u >= 0:
		if u % 40 < 10:
			for _i in 30:
				var p = position #Vector2(rand_range(-64, 1064), -32)
				var a = rand_range(-60, 60) - 90 #rad2deg( root.player.position.angle_to_point(p) ) + rand_range(-1, 1) * 5
				var s = rand_range(3, 12)
				var s2 = rand_range(12, 24)
				var b = Bullets.create_bullet(p, s, a, -s / 60.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.RED, true, 0.0, 0.0, BLEND_MODE_ADD)
				Bullets.queue_update_bullet(b, 60, null, null, null, 0.5, s2)
				Bullets.queue_aim_at_player(b, 60);
				Bullets.queue_offset_angle(b, 60, rand_range(-8, 8))

func scaline():
	var u = t - 120
	if u >= 0:
		if u == 0:
			a = 0
		
		root.shoot1.play()
		Bullets.create_bullet(position, 4.0, a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.BLUE)
		Bullets.create_bullet(position, 4.0, 180+a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.BLUE)
		a += 43
		if u >= 120:
			Bullets.create_bullet(position, 5.0, -a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.CYAN)
			Bullets.create_bullet(position, 5.0, 180-a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.CYAN)
		if u >= 240:
			Bullets.create_bullet(position, 6.0, 72+a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.TEAL)
			Bullets.create_bullet(position, 6.0, 180+72+a, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.TEAL)
			
			
		if (u + 1) % 180 == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			dest = Vector2(x, position.y)

func kana():
	var CYCLE_TIME = 300
	var u = t - 60
	var difficulty = 3
	var arms = [3, 5, 7, 7]
	var step = [0.9, 0.7, 0.8, 1]
	var step2 = 0.2 if difficulty == 3 else 0.0666
	var rate = 2 if difficulty == 3 else 3
	var mspeed = 1.25
	if u >= 0:
		if u % CYCLE_TIME == 0:
			a = -90.0
			a2 = 0.0
			a3 = 8
			lr *= -1
		if u % CYCLE_TIME >= 90:
			a += step[difficulty] * lr * PI
			a3 -= step2
		if u % rate == 0 && u % CYCLE_TIME >= 60:
			root.shoot1.play()
			for i in arms[difficulty]:
				Bullets.create_bullet(position, 8, a + i * 360.0/arms[difficulty], 0.0, 0.0, Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.BLUE)
				Bullets.create_bullet(position, 8, a + i * 360.0/arms[difficulty], -0.067, max(mspeed,a3), Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.BLUE_D)
			
		if (u+1) % CYCLE_TIME == 0:
			var x = rand_range( max(Constants.FIELD_SIZE.x*0.3, position.x - 200 * (position.x / Constants.FIELD_SIZE.x)), min(Constants.FIELD_SIZE.x*0.7, position.x + 200 * (1 - position.x / Constants.FIELD_SIZE.x))  )
			var y = rand_range( max(Constants.FIELD_SIZE.y*0.15, position.y - 150 * (position.y / Constants.FIELD_SIZE.y)), min(Constants.FIELD_SIZE.y*0.3, position.y + 150 * (1 - position.y / Constants.FIELD_SIZE.y))  )
			dest = Vector2(x, 300)

func bhe():
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var u = t - 60
	if u >= 0:
		a += 1.7
		if u % 3 == 0:
			for i in 21:
				Bullets.create_bullet(position, 5, a + i * 360 / 21, 0.0, 0.0, Constants.BULLET_TYPE.ARROWHEAD, COLOURS[i/3], true, 0.0, 0.0, BLEND_MODE_ADD)

func godot_piece(pos, speed, ang):
	for i in range(-7, 8):
		var p = pos + Vector2(64, i*8.5).rotated(deg2rad(ang))
		var b = Bullets.create_bullet(p, speed, ang, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
		#b.bounce_count = 1
	for i in range(9):
		var p = pos + Vector2(64-i*64.0/6.1, 59.5+i*3.1).rotated(deg2rad(ang))
		var b = Bullets.create_bullet(p, speed, ang, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
		#b.bounce_count = 1
		p = pos + Vector2(64-i*64.0/6.0, -59.5-i*3.1).rotated(deg2rad(ang))
		b = Bullets.create_bullet(p, speed, ang, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
		#b.bounce_count = 1
		

func godot():
	var u = t - 120
	if u >= 0:
		if u % 90 == 0:
			a = randf()*360.0
			for i in 17:
				godot_piece(position, 3, a + i*360/17)
		if u % 90 == 24:
			for i in 17:
				godot_piece(position, -3, a + (i)*360/17)

var fade_radius = 0
var FADE_RAD_MAX = 1000

func _process(delta):
	
	#misdirection()
	#bowap()
	#bowap2()
	#qed()
	#qed2()
	#water()
	#fire()
	#test_ndl()
	#shark()
	#spark()
	#dbdb()
	#bls()
	#kanko()
	#chimata()
	#meek()
	#bullet_test()
	#funny_junko2()
	#rainbarf()
	#ds()
	if phase == 0:
		#godot()
		#bhe()
		#kana()
		#scaline()
		#mek()
		#incinerate()
		#firesaber()
		#firesaber2()
		#funny_junko2()
		#shapeattack3()
		#shapeattack4()
		#current()
		super_laser_piss()
		#tss2()
		#waterdance()
		#firewily()
		#wrasse()
		#shark()
		#flick()
		#lasagnacode()
		#backstab()
		#losemoney()
		#position.y = Constants.FIELD_SIZE.y * 0.35
		#dest.y = Constants.FIELD_SIZE.y * 0.35
		#ds()
		#pass
		#pl2()
		#fire()
		#test_ndl()
		#bowap()
		#water()
		#funny_junko2()
		#satorinon1()
		#satorinon2()
		#mek()
		#tsukasa()
		#tsukasa2()
		#wraparound()
		#himemushi()
		#war_of_the_roses()
		#futo()
		#mandrill()
		#mandrill2()
		#mandrill3()
		#mandrill4()
		#fake_guze()
		#overflow()
		#crossfire()
		#mike()
		#speen()
		#megumu()
		#satorinon1()
		#clownnon()
		#thunder2()
		#bullet_test()
		#gears_of_war()
		#warsaw()
		pass
		
	elif phase == 1:
		pass
		#ds()
		#fire()
		#test_ndl()
		#bowap2()
		#water()
		#funny_junko2()
		megumu()
		#satorinon1()
		#mandrill2()
	elif phase == 2:
		#test_ndl()
		#bowap2()
		#water()
		mandrill3()
		#funny_junko2()
		#satorinon1()
	elif phase == 3:
		#t = 0
		dest = Vector2(Constants.FIELD_SIZE.x * 0.5, Constants.FIELD_SIZE.y * 0.3)
		position = dest
		thunder2()
		#satorinon2()
	elif phase == 4:
		dest = Vector2(Constants.FIELD_SIZE.x * 0.5, Constants.FIELD_SIZE.y * 0.3)
		#t = 0
		fire()
	elif phase == 5:
		bowap()
	elif phase == 6:
		megumu()
	elif phase == 7:
		#t = 0
		dest.x = Constants.FIELD_SIZE.x * 0.5
		dest.y = Constants.FIELD_SIZE.y * 0.2
		
		funny_junko2()
	
	if $Healthbar.value >= health:
		$Healthbar.value = health
	else:
		$Healthbar.value += delta * $Healthbar.max_value
	
	if health <= 0:
		#Bullets.clear_screen()
		fade_radius = FADE_RAD_MAX
		t = 0
		phase += 1
		health = 15000
		if phase == 6:
			a = 0
		if phase == 7:
			a = 0
			health = 60000
		$Healthbar.max_value = health
		root.warp.warp(position, 16)
		root.blast.play()
		Bullets.deactivate_screen()
		#queue_free()	
		for _i in 50:
			Bullets.create_item(position, Constants.ITEM.POINT, true, randf()*360.0, rand_range(12.0, 20.0))
			Bullets.create_item(position, Constants.ITEM.POWER, true, randf()*360.0, rand_range(12.0, 20.0))
		Bullets.create_item(position, Constants.ITEM.BOMB_FRAGMENT, true, 180.0, 5.0)
		Bullets.create_item(position, Constants.ITEM.LIFE_FRAGMENT, true, 0.0, 5.0)
		#Bullets.create_item(position, Constants.ITEM.LIFE_FRAGMENT, true, 0.0, 0.0)
	if fade_radius > 0:
		Bullets.clear_screen_fade(position, FADE_RAD_MAX - fade_radius, true)
		fade_radius -= 16
	position += (dest - position) / weight
	
	t += 1

func hit(damage):
	health -= damage
	root.score += 10
	if health > 3000:
		Globals.root.hit.play()
	else:
		Globals.root.hit2.play()

