extends Node2D

const GOLDEN_ANGLE = PI * (3 - sqrt(5))

onready var Constants = get_node('/root/Constants')
onready var player = get_node('player')

onready var Bullets = get_node("BulletHandler")

var graze = 0
var score = 0
var piv = 10000

onready var warp = get_node("posteffects/warp")

onready var warning1 = get_node("warning1")
onready var warning2 = get_node("warning2")
onready var shoot1 = get_node("shoot1")
onready var shoot3 = get_node("shoot3")
onready var laser1 = get_node("laser1")
onready var blast = get_node("blast")
onready var charge1 = get_node("charge1")
onready var charge2 = get_node("charge2")
onready var rumble1 = get_node("rumble1")
onready var rumble2 = get_node("rumble2")
onready var cardget = get_node("cardget")

onready var hit = get_node("hit")
onready var hit2 = get_node("hit2")

var fast_forward = false

var shake_frames = 0
var shake_intensity = 64

var bg_flag = 0

var dialogue = true

var scb_failed = false


func _ready():
	Globals.root = self
	#seed(69)
	randomize()
	Engine.target_fps = 60
	#OS.window_fullscreen = true
	#Bullets.set_active_bullets(active_bullets)
	#Bullets.set_free_bullets(free_bullets)
	
	#get_node("../AnimationPlayer").play("spin")
	

	#p = Constants.FIELD_SIZE * .5
	#p2 = Constants.FIELD_SIZE * .5

	
const mode = 1

func agni_brilliance():
	var lr = 1
	if posmod(t-120, 300) < 90:
		var j = 0
		while (j < 3):
			var b = Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 4, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, lr * (randf()*2 + 0.5), 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 100 + randi()%40, null, null, null, null, null, null, null, null, 0.0)
			var b2 = Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 4, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, lr * (randf()*2 + 0.5), 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b2, 100 + randi()%40, null, null, null, null, null, null, null, null, 0.0)
			j += 1
			lr *= -1
		Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 4 + randf()*6, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.BLUE, false, 0.0, 137, BLEND_MODE_ADD)
		

func emerald_megalith():
	if t % 20 == 0:
		var x = Constants.FIELD_SIZE.x * (0.2+randf()*0.6)
		var y = Constants.FIELD_SIZE.y * (0.1+randf()*0.2)
		var s = 4 + randf()*6
		for i in range(3):
			Bullets.create_bullet(Vector2(x,y), s, 90 + (i-1)*30, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.GREEN, true, 0.0, 137, BLEND_MODE_ADD)
		var i = 0
		while i < 40:
			Bullets.create_bullet(Vector2(x,y), 3+randf()*6, randf()*360.0, 0.0, 0.0, Constants.BULLET_TYPE.BALL_OUTLINE, Constants.COLOURS.GREEN)
			i += 1

func funny_junko():
	if t % 120 == 0:
		var a = randf()*360.0
		for i in range(120):
			Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 8, a + i*3, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			var b = Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 8, a + (i+0.5)*3, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 60, null, null, null, -0.5, 4.0)


func funny_junko3():
	var density = 24
	var lr = 1
	if t % 360 >= 180: lr *= -1
	if t % 180 == 0:
		var a = randf()*360.0
		for i in range(density):
			for j in range(16):
				Bullets.create_bullet(Constants.FIELD_SIZE / 2 + Vector2(0, -200), 1.5+j*0.75, a + i*360/density + lr * j * 2, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.RED, true, 0.0, 0.0, BLEND_MODE_ADD)

func ooe():
	var lr = 1
	if t % 720 > 360:
		lr *= -1
	if t % 5 == 0 || t % 5 == 3:
		var x = (lr * 0.5 + 0.5) * Constants.FIELD_SIZE.x + lr * 127
		var s = randf()
		var y = (1.2*s-0.2) * Constants.FIELD_SIZE.y
		var speed = (1.2-s) * 20
		Bullets.create_bullet(Vector2(x, y), speed, 90 + lr * 42 + randf()*6, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.BLUE, false, 0.0, 137.0, BLEND_MODE_ADD)
	if t % 3 == 0:
		var y = -128
		var s = randf()
		var x = (-1.2*s + 1.2) * Constants.FIELD_SIZE.x
		var speed = (2-s) * 16
		Bullets.create_bullet(Vector2(x, y), speed, 90 + lr * 42 + randf()*6, 0.0, 0.0, Constants.BULLET_TYPE.BUBBLE, Constants.COLOURS_LARGE.BLUE, false, 0.0, 137.0, BLEND_MODE_ADD)
			

func coo():
	if t % 2 == 1:
		var x = (randf()*0.6 + 0.2) * Constants.FIELD_SIZE.x
		var y = (randf()*0.3 + 0.1) * Constants.FIELD_SIZE.y
		var a = randf()*360.0
		var lr = (randi()%2) * 2 - 1
		
		for i in range(10):
			Bullets.create_bullet(Vector2(x, y), 6 + i * 0.15, a + lr * 2 * i, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE)

func star():
	var COLOURS = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	var COLOURS_L = [Constants.COLOURS_LARGE.RED, Constants.COLOURS_LARGE.ORANGE, Constants.COLOURS_LARGE.YELLOW, Constants.COLOURS_LARGE.GREEN, Constants.COLOURS_LARGE.CYAN, Constants.COLOURS_LARGE.BLUE, Constants.COLOURS_LARGE.PURPLE]
	var density = 10
	var c = int(t / 12) % 7
	if t % 12 < 5:
		warning1.play()
		for i in range(density):
			var angle = t + i * 360 / density
			#Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + 480 * Vector2(cos(angle), sin(angle)), 2, 1.875 * t + i * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.STAR, COLOURS[c], 0.0, 0.1)
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + 500 * Vector2(cos(deg2rad(angle)), sin(deg2rad(angle))), 2.5, 1.65 * t + i * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.STAR, COLOURS[c], true, 0.0, 0.1)
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + 500 * Vector2(cos(deg2rad(angle)), sin(deg2rad(angle))), 2.5, 1.65 * t + i * 360 / density + 180, 0.0, 0.0, Constants.BULLET_TYPE.STAR, COLOURS[c], true, 0.0, 0.1)
			#Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + 480 * Vector2(cos(t + i * 360 / density), sin(t + i * 360 / density)), 2, 1.65*t + i * 360 / density+180, 0.0, 0.0, Constants.BULLET_TYPE.STAR, COLOURS[c], 0.0, 0.1)
	
	if t % 180 == 180:
		var a = (Constants.FIELD_SIZE * 0.5).angle_to_point(player.position)
		for i in range(12):
			var angle = a + i * 360 / 12.0
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5, 2.0, angle, 0.0, 0.0, Constants.BULLET_TYPE.STAR_LARGE, COLOURS_L[c], true, 0.0, 0.1)
			

func tss():
	var density = 90
	if t % 30 == 0:
		shoot1.play()
		for i in density:
			Bullets.create_bullet(Constants.FIELD_SIZE*0.5-Vector2(0,160), 2.5, i * 360.0 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, -0.0, 0.0, BLEND_MODE_ADD)
	if t % 30 == 20:
		shoot1.play()
		var o = randf() * 360.0
		for i in density:
			Bullets.create_bullet(Constants.FIELD_SIZE*0.5-Vector2(0,160), 2.5, (i + 0.5) * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.BALL, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
	

func rain():
	if t % 5 == 0 || t % 5 == 2 || t % 5 == 4:
		Bullets.create_bullet( Vector2(((0.5 + randf()-0.5)) * Constants.FIELD_SIZE.x, Constants.FIELD_SIZE.y * (randf()*0.3-0.1)), 4 + randf()*8, 60 + randf()*10, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD) 
	if t % 2 == 0:
		Bullets.create_bullet( Vector2(randf()*-50, Constants.FIELD_SIZE.y * randf()), 4 + randf()*8, 60 + randf()*10, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD) 

func bowap():
	var DENSITY = 3.0
	var a = pow(t-30,2)*0.025
	
	if t % 3 == 0:
		for i in range(DENSITY):
			Bullets.create_loose_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 5, 90 + a + i * 360.0 / DENSITY, 400.0, 64.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD) 


var oset = 0.0	
func shou_new():
	#var colours = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	#var DENSITY = 1.0
	#var a = pow(t-30,2)*0.07345673489
	var lr = 1 if t % 600 < 300 else -1
	if t % 300 == 0 || t % 300 == 120:
		oset = (randf()-0.5) * 5
	if t % 300 >= 0 && t % 300 <= 14:
		var i = 8 - t % 300
		var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, oset - (90 + 45 * lr) + lr * i * 8, 45.0, 48.0, -0.25, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, true, 4.3 * lr, BLEND_MODE_ADD) 
		Bullets.queue_update_curve_laser(l, 50, null, null, null, 0.5, 30, null, null, null, 0.0)
		Bullets.queue_update_curve_laser(l, 95, null, null, null, null, null, null, null, null, lr*12.0)
		Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, -lr*12.0)
		Bullets.queue_update_curve_laser(l, 105, null, null, null, null, null, null, null, null, 0.0)

	if t % 300 >= 120 && t % 300 <= 120+14:
		var i = 8 - (t % 300) + 120
		var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, oset - (90 - 45 * lr) - lr * i * 8, 45.0, 48.0, -0.25, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, true, -4.3 * lr, BLEND_MODE_ADD) 
		Bullets.queue_update_curve_laser(l, 50, null, null, null, 0.5, 30, null, null, null, 0.0)
		Bullets.queue_update_curve_laser(l, 95, null, null, null, null, null, null, null, null, -lr*12.0)
		Bullets.queue_update_curve_laser(l, 100, null, null, null, null, null, null, null, null, lr*12.0)
		Bullets.queue_update_curve_laser(l, 105, null, null, null, null, null, null, null, null, 0.0)

	if t % 300 >= 180 && t % 300 <= 180+8:
		var i = 8 - (t % 300) + 180
		var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, -60 + i * 11, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, true, 4.3, BLEND_MODE_ADD) 
		Bullets.queue_update_curve_laser(l, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
		var l2 = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, -120 - i * 11, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, true, -4.3, BLEND_MODE_ADD) 
		Bullets.queue_update_curve_laser(l2, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
		#c += 1

	if t % 300 in [180, 190, 200, 210, 220, 230, 240]:
# warning-ignore:shadowed_variable
		var offset = (randf()-0.5) * 2 * 12 + rad2deg(player.position.angle_to_point(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200))) - 90.0
		for i in range(15):
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 8.0, offset + i * 12, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.WHITE, true, 0.0, 0.0, BLEND_MODE_ADD) 
			pass
			#https://streamable.com/7twv5b

	
func shou():
	var colours = [Constants.COLOURS.RED, Constants.COLOURS.ORANGE, Constants.COLOURS.YELLOW, Constants.COLOURS.GREEN, Constants.COLOURS.CYAN, Constants.COLOURS.BLUE, Constants.COLOURS.PURPLE]
	#var DENSITY = 1.0
	#var a = pow(t-30,2)*0.07345673489
	#var a = t*7-90
	#var c = 0
	var lr = 1 if t % 600 < 300 else -1
	if t % 300 == 0:
# warning-ignore:shadowed_variable
		var offset = (randf()-0.5) * 5
		for i in range(11):
			#create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 10, 90 + a + i * 360.0 / DENSITY, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.RED, true, 0.0, 0.0, BLEND_MODE_ADD) 
			#create_loose_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 10, 90 + a + i * 360.0 / DENSITY, 360.0, 32.0, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS.RED, true, 0.0, 0.0, BLEND_MODE_ADD) 
			var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, offset - (90 + 40 * lr) + lr * i * 8, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LIGHTNING, 0, true, 4.3 * lr, BLEND_MODE_ADD) 
			Bullets.queue_update_curve_laser(l, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
			#c += 1
	if t % 300 == 120:
# warning-ignore:shadowed_variable
		var offset = (randf()-0.5) * 5
		for i in range(11):
			var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, offset - (90 - 40 * lr) - lr * i * 8, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LIGHTNING, 0, true, -4.3 * lr, BLEND_MODE_ADD) 
			Bullets.queue_update_curve_laser(l, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
			#c += 1
	if t % 300 == 180:
		for i in range(7):
			var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, -60 + i * 11, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LEGACY_LASER, colours[2], true, 4.3, BLEND_MODE_ADD) 
			Bullets.queue_update_curve_laser(l, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
			var l2 = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 15.0, -120 - i * 11, 30.0, 64.0, -0.25, 0.0, Constants.BULLET_TYPE.LEGACY_LASER, colours[2], true, -4.3, BLEND_MODE_ADD) 
			Bullets.queue_update_curve_laser(l2, 45, null, null, null, 0.5, 30, null, null, null, 0.0)
			#c += 1

	if t % 300 in [180, 190, 200, 210, 220]:
# warning-ignore:shadowed_variable
		var offset = (randf()-0.5) * 20
		for i in range(15):
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0, -200), 10, offset + i * 12, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD) 
			pass
			#https://streamable.com/7twv5b

func raiko():
	var lr = 1 if t % 720 < 360 else -1
	
	
	if t % 7 == 0:
		var p = Constants.FIELD_SIZE * 0.5 + Vector2(1,1).rotated(randf()*360.0) * randf()*128.0 + Vector2(0, - 150)
		var angle2 = rad2deg(player.position.angle_to_point(p)) + (randf()-0.5) * 20
		Bullets.create_bullet(p, 3 + randf()*6, angle2, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD);
	
	if t % 360 < 240 && t % 2 == 0:
		var a = -t * 68.753882025 * lr
		var l = Bullets.create_curve_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0, -150), 15.0, a, 60.0, 96.0, 0.0, 0.0, Constants.BULLET_TYPE.LIGHTNING, Constants.COLOURS_LARGE.BLUE, true, lr*1.75, BLEND_MODE_ADD) 
		Bullets.queue_update_curve_laser(l, 60, null, null, null, null, null, null, null, null, 0.0)


var offset = 0.0

func hahae():
	var density = 24
	if t % 300 == 0:
		offset = randf()*360.0
	if t % 300 < 230 && t % 2 == 0:
		for i in range(density):
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0, -300), 20, offset + i * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.MENTOS, 0, true, 2, 0.0, BLEND_MODE_ADD) 
			pass
			#https://streamable.com/7twv5b
			
	if t % 300 < 230 && t % 300 >= 60 && t % 2 == 0:
		for i in range(density):
			Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0, -300), 20, offset + i * 360 / density, 0.0, 0.0, Constants.BULLET_TYPE.MENTOS, 0, true, -2, 0.0, BLEND_MODE_ADD) 
			pass
			#ht


func milky_way():
	if t % 10 == 0:
		var lr = (randi()%2)*2-1
		var pos = Vector2(Constants.FIELD_SIZE.x+20, Constants.FIELD_SIZE.y * randf())
		Bullets.create_curve_laser(pos, 10, 180 - lr * 60, 45, 32, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, false, lr*1, BLEND_MODE_ADD)

	if t % 10 == 5:
		var lr = (randi()%2)*2-1
		var pos = Vector2(-20, Constants.FIELD_SIZE.y * randf())
		Bullets.create_curve_laser(pos, 10,  - lr * (40.0+randf()*20.0), 45, 32, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.YELLOW, false, lr*1, BLEND_MODE_ADD)

	if t % 30 == 0:
		var p1 = Constants.FIELD_SIZE*0.5 + Vector2(200, -100)
		var p2 = Constants.FIELD_SIZE*0.5 + Vector2(-200, -100)
		var a1 = rad2deg(player.position.angle_to_point(p1))
		var a2 = rad2deg(player.position.angle_to_point(p2))
		Bullets.create_bullet(p1, 6, a1, 0.0, 0.0, Constants.BULLET_TYPE.STAR, Constants.COLOURS.BLUE, true, 0.0, -0.15)
		Bullets.create_bullet(p2, 6, a2, 0.0, 0.0, Constants.BULLET_TYPE.STAR, Constants.COLOURS.BLUE, true, 0.0, 0.15)
		

func source():
	var a = t * 0.75
	match t % 2:
		0:
			var b = Bullets.create_bullet( Vector2(Constants.FIELD_SIZE.x * 0.125 + (randf()-0.5)*64, -10), 10, 88.0 + randf()*4.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, false, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 70, null, 2 + randf()*3, -a)
			#Bullets.queue_update_bullet(b, 60, null, 2 + randf()*3, -a, null, null, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.RED, true, BLEND_MODE_MIX)
			b = Bullets.create_bullet( Vector2(Constants.FIELD_SIZE.x * 0.875 + (randf()-0.5)*64, -10), 10, 88.0 + randf()*4.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, false, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 70, null, 2 + randf()*3, 0+a)
			#Bullets.queue_update_bullet(b, 60, null, 2 + randf()*3, 0+a, null, null, Constants.BULLET_TYPE.ARROWHEAD, Constants.COLOURS.PURPLE, true, BLEND_MODE_MIX)
		1:
			var b = Bullets.create_bullet( Vector2(Constants.FIELD_SIZE.x * 0.625 + (randf()-0.5)*64, -10), 10, 88.0 + randf()*4.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, false, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 70, null, 3 + randf()*3, 'at player')
			#Bullets.queue_update_bullet(b, 60, null, 3 + randf()*3, 'at player', null, null, Constants.BULLET_TYPE.RICE, Constants.COLOURS.BLUE, true, BLEND_MODE_MIX)
			b = Bullets.create_bullet( Vector2(Constants.FIELD_SIZE.x * 0.375 + (randf()-0.5)*64, -10), 10, 88.0 + randf()*4.0, 0.0, 0.0, Constants.BULLET_TYPE.FIREBALL, Constants.COLOURS_LARGE.BLUE, false, 0.0, 0.0, BLEND_MODE_ADD)
			Bullets.queue_update_bullet(b, 70, null, 3 + randf()*3, 'at player')
			#Bullets.queue_update_bullet(b, 60, null, 3 + randf()*3, 'at player', null, null, Constants.BULLET_TYPE.RICE, Constants.COLOURS.GREEN, true, 0.0, 0.0, BLEND_MODE_MIX)

func funny_bounce():
	if t % 4 == 0: 
		var b = Bullets.create_bullet(Constants.FIELD_SIZE * 0.5 + Vector2(0,-200), 6 + randf()*3, randf()*360, 0.0, 0.0, Constants.BULLET_TYPE.DIVINE_SPIRIT, Constants.COLOURS_DIVINE_SPIRIT.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD);
		#var b = Bullets.create_loose_laser(Constants.FIELD_SIZE * 0.5 + Vector2(0,-200), 6 + randf()*3, randf()*360, 200, 64, 0.0, 0.0, Constants.BULLET_TYPE.LASER, Constants.COLOURS_LARGE.BLUE, true, 0.0, 0.0, BLEND_MODE_ADD)
		b.bounce_count = 4
		#Bullets.queue_delete(b, Constants.TRANSFORM_COND.BOUNCE)

func funny_rng():
	var x = randf()*Constants.FIELD_SIZE.x
	var y = randf()*Constants.FIELD_SIZE.y
	var s = 2 + randf()*8
	var a = randf()*360.0
	var type = randi()%Constants.BULLET_TYPE.DIVINE_SPIRIT
	var c = 0
	var glow = BLEND_MODE_MIX
	var spin = 0.0
	if type < Constants.BULLET_TYPE.COIN || type == Constants.BULLET_TYPE.SNOWBALL || type == Constants.BULLET_TYPE.DROPLET:
		c = randi()%Constants.COLOURS.WHITE
	elif type == Constants.BULLET_TYPE.COIN:
		c = randi()%Constants.COLOURS_COIN.BRONZE
	elif type == Constants.BULLET_TYPE.DIVINE_SPIRIT:
		c = randi()%Constants.COLOURS_DIVINE_SPIRIT.GREY_D
		glow = BLEND_MODE_ADD
	else:
		c = randi()%Constants.COLOURS_LARGE.ORANGE
	if type == Constants.BULLET_TYPE.FIREBALL || type == Constants.BULLET_TYPE.BUBBLE || type == Constants.BULLET_TYPE.LEGACY_LASER:
		glow = BLEND_MODE_ADD
	if type == Constants.BULLET_TYPE.STAR || type == Constants.BULLET_TYPE.STAR_LARGE || type == Constants.BULLET_TYPE.COIN || type == Constants.BULLET_TYPE.POPCORN:
		spin = 0.2
		
	Bullets.create_bullet(Vector2(x,y), s, a, 0.0, 0.0, type, c, true, rand_range(-2, 2), spin, glow)


var t = -1

var timeleft = 300

func _process(_delta):
	
	#agni_brilliance()
	#emerald_megalith()
	#funny_junko()
	#omnitrix()
	#funny_junko3()
	#ooe()
	#coo()
	#star()
	#tss()
	#rain()
	#shou()
	#shou_new()
	#bowap()
	#raiko()
	#hahae()
	#milky_way()
	#source()
	#funny_bounce()
	#funny_rng()
	t += 1
	
	fast_forward = Input.is_action_pressed("fast_forward")
	var slow = Input.is_action_pressed("debug_slow")
	Bullets.fast_forward = fast_forward
	
	if fast_forward:
		Engine.target_fps = 9999
	elif slow:
		Engine.target_fps = 30
	else:
		Engine.target_fps = 60
	
	if Input.is_action_just_pressed("reset"):
		for b in Bullets.active_bullets:
			b.free()
		Bullets.active_bullets.clear()
		for b in Bullets.free_bullets:
			b.free()
		Bullets.free_bullets.clear()
		for b in Bullets.loose_lasers:
			b.free()
		Bullets.loose_lasers.clear()
		for b in Bullets.straight_lasers:
			b.free()
		Bullets.straight_lasers.clear()
		for l in Bullets.curve_lasers:
			for b in l.bullets:
				b.free()
		Bullets.curve_lasers.clear()
		Bullets.clearing_bullets.clear()
		for i in Bullets.active_items:
			i.free()
		Bullets.active_items.clear()
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		Globals.graze = 0

	timeleft -= 1
	if timeleft <= 0:
		timeleft = 300 + randi()%300
	
	if shake_frames > 0:
		shake_frames -= 1
		get_parent().position = Vector2(960, 540) + Vector2(shake_intensity * min(1.0, shake_frames / 30.0) * randf(), 0).rotated(randf()*360.0)
	else:
		get_parent().position = Vector2(960, 540)
	#print(get_node("BulletRender").BulletRendererMesh.visible_instance_count)
