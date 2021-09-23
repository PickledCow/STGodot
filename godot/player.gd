extends Node2D

export var pid = 0

export var death_effect_path: NodePath
onready var death_effect = get_node(death_effect_path)

var add_material = preload('res://bullet/add.tres')

onready var Constants = get_node('/root/Constants')
onready var Sprite = get_node("Sprite")
onready var hitbox1 = get_node("focus")
onready var hitbox2 = get_node('focus2')
onready var focus_animation = get_node("focusanimation")

var facing = 1
var moving = false

var Shot = preload("res://player/shot.tscn")

onready var shot_sprites = [load("res://player/p"+str(pid)+"/0.tres"),  load("res://player/p"+str(pid)+"/1.tres"), load("res://player/p"+str(pid)+"/2.tres")]

var root: Node2D
onready var Bullets = Globals.Bullets

var hitbox_radius = 4.0
var graze_ratio = 20.0

var focused = false

var graze_piv_progress = 0

var lives = 2
var life_fragments = 0
var life_requirement = 3
var bombs = 3
var bomb_fragments = 0
var bomb_requirement = 5
var power = 4
var power_decimal = 0

var speed = 9
var focus_speed = 4

var anim_time = 0.1
var anim_timer = 0.0
var anim_frame = 0
var turn_frame = 0

var graze_this_frame = 0

var got_hit = false
var dead = false
var death_wave_radius = 0.0

var deathbomb_timer = 0
var deathbomb_window = 15

var respawning = false
var respawn_timer = 0
var respawn_time = 120

var respawn_iframes = 5 * 60
var bomb_iframes = 8 * 60
var i_frame_timer = 0

onready var hurt_sound = get_node("Hurt")
onready var graze_sound = get_node("Graze")
onready var bomb_sound = get_node("bomb")

onready var graze_particles = get_node("GrazeParticles")

onready var option_sprites = [get_node("options/option0"),get_node("options/option1"),get_node("options/option2"),get_node("options/option3")]

var prev_pos = [Vector2(), Vector2(), Vector2(), Vector2()]

var shooters_unfocus = []
var shooters_focus = []

var option_positions_unfocus = []
var option_positions_focus = []

var option_interp = 0.0 # 0 unfocus 1 focus
var option_travel_speed = 0.15

class Shooter:
	var fire_rate = 3
	var start_delay = 0
	var fire_timer = 0
	
	var damage = 10
	var offset = Vector2(0,0)
	var hitbox = Vector2(0,0)
	var angle = -PI/2
	var speed = 50
	var accel = 0
	var max_speed = 0
	
	var radial_homing = false
	var lateral_homing = false
	
	var stationary_piercing = false
	var laser_animated = false
	
	var sprite
	var blend = 0
	var option = -1
	

func _ready():
	for i in len(prev_pos):
		prev_pos[i] = position
	
	death_effect.material.set_shader_param("radius", 0)
	root = get_parent()
	Globals.player = self
	
	var tex = load("res://player/p"+str(pid)+"/pl.png")
	
	for option in option_sprites:
		option.texture = tex
	
	Sprite.texture = tex
	
	var shot_data_file = File.new()
	shot_data_file.open("res://player/p"+str(pid)+"/shot.json", File.READ)
	
	var shot_data_json = JSON.parse(shot_data_file.get_as_text())
	shot_data_file.close()
	var shot_data = shot_data_json.result
	
	for options in shot_data["option_pos"]["unfocused"]:
		if options == null:
			continue
		var option_array = []
		for option in options:
			option_array.append(Vector2(option["x"], option["y"]))
		option_positions_unfocus.append(option_array)
		
	for options in shot_data["option_pos"]["focused"]:
		if options == null:
				continue
		var option_array = []
		for option in options:
			option_array.append(Vector2(option["x"], option["y"]))
		option_positions_focus.append(option_array)
		
	for sht_pwr in shot_data["sht_arr"]["unfocused"]:
		var shooters = []
		for shooter_data in sht_pwr:
			var shooter = create_shooter(shooter_data)
			shooters.append(shooter)
		shooters_unfocus.append(shooters)
		
	for sht_pwr in shot_data["sht_arr"]["focused"]:
		var shooters = []
		for shooter_data in sht_pwr:
			var shooter = create_shooter(shooter_data)
			shooters.append(shooter)
		shooters_focus.append(shooters)

func create_shooter(shooter_data):
	var shooter = Shooter.new()
	shooter.fire_rate = shooter_data["fire_rate"]
	shooter.start_delay = shooter_data["start_delay"]
	shooter.damage = shooter_data["dmg"]
	shooter.offset = Vector2(shooter_data["off_x"], shooter_data["off_y"])
	shooter.hitbox = Vector2(shooter_data["hitbox_y"], shooter_data["hitbox_x"])
	shooter.angle = shooter_data["angle"]
	shooter.speed = shooter_data["speed"]
	shooter.option = shooter_data["option"] - 1
	shooter.sprite = shot_sprites[shooter_data["anm"]]
	match shooter_data["func_on_init"]:
		1.0:
			shooter.radial_homing = true
		2.0:
			shooter.stationary_piercing = true
			shooter.laser_animated = true
		3.0:
			shooter.accel = 0.5
			shooter.max_speed = 32
		4.0:
			shooter.lateral_homing = true
	shooter.blend = shooter_data["unknown_sht_int32"]
	return shooter

func check_collision():
	var col = Bullets.player_collision(position, hitbox_radius, hitbox_radius*graze_ratio, focused)
	if col[0] && i_frame_timer <= 0:
		hit()
	if col[1] > 0:
		graze()
	graze_this_frame = col[1]
	graze_piv_progress += col[1]
	root.piv += 10 * (graze_piv_progress / 10)
	graze_piv_progress -= 10 * (graze_piv_progress / 10)
	
	var items_collected = col[2]
	
	var life = items_collected[Constants.ITEM.LIFE]
	life_fragments += life_requirement * life
	var life_frag = items_collected[Constants.ITEM.LIFE_FRAGMENT]
	life_fragments += life_frag
	var bomb = items_collected[Constants.ITEM.BOMB]
	bomb_fragments += bomb_requirement * bomb
	var bomb_frag = items_collected[Constants.ITEM.BOMB_FRAGMENT]
	bomb_fragments += bomb_frag
	var powr = items_collected[Constants.ITEM.POWER]
	power_decimal += powr
	if items_collected[Constants.ITEM.FULL]:
		power_decimal = 400
	var points = items_collected[Constants.ITEM.POINT]
	var raw_piv = root.piv if position.y < 350.0 else int(10.0 * floor(0.1 * root.piv * (position.y - 350.0) / 1300.0 + 1.0))
	root.score += points * raw_piv
	var piv = items_collected[Constants.ITEM.PIV]
	root.piv += piv * 10
	
	if powr || points || piv:
		$item.play()
	
	if bombs > 8:
		bombs = 8
		bomb_fragments = 0
	
	while life_fragments >= life_requirement:
		$extend.play()
		lives += 1
		life_fragments -= life_requirement
	lives = max(0, lives)
	

	while bomb_fragments >= bomb_requirement:
		$spellextend.play()
		bombs += 1
		bomb_fragments -= bomb_requirement

func graze():
	#graze_this_frame += 1
	#Globals.graze += 1
	graze_sound.play()

func hit():
	hurt_sound.play()
	root.scb_failed = true
	#Bullets.clear_screen_fade(position, 128, true)
	if false:
		deathbomb_timer = deathbomb_window
		got_hit = true
	$deathcircle.rotation = TAU * randf()
	$deathcircle/AnimationPlayer.play("death1" if randi()%2==0 else "death2")
	#dead = true
	#$Sprite.hide()
	#$blood.emitting = true
	$deathparticles.emitting = true
	#got_hit = true

func move():
	var move = Vector2(0,0)
	
	if Input.is_action_pressed("left"):
		move.x = -1
	elif Input.is_action_pressed("right"):
		move.x = 1
	if Input.is_action_pressed("down"):
		move.y = 1
	elif Input.is_action_pressed("up"):
		move.y = -1
	
	moving = true if move.x else false
	
	if Input.is_action_pressed('focus'):
		$focus.visible = true
		$focus2.visible = true
		position += move.normalized() * focus_speed
		if !focused:
			focus_animation.play("focus")
		focused = true
	else:
		focused = false
		position += move.normalized() * speed
		$focus.visible = false
		$focus2.visible = false
	
	#position.y -= 1.5
	#position.x =  Constants.FIELD_SIZE.x * 0.5 + sin(root.t * 0.01) * Constants.FIELD_SIZE.x * 0.45
	
	if false:
		#focused = true
		#$focus.visible = true
		#$focus2.visible = true
		var force = Vector2()
		var wall_force = 0.000001
		for b in Bullets.active_bullets:
			var diff = (position - (b.position + b.direction * b.speed))
			var length = diff.length_squared() - b.size
			var dot = diff.normalized().dot(b.direction)
			var weight = max(0, dot * b.speed) * 0 + 1
			if length < 500*500:
				force += weight * diff.normalized() / (length * length)
			
	#force.y *= 0.1
		position += force.normalized() * speed
	
	
	position.x = clamp(position.x, 18, Constants.FIELD_SIZE.x - 18)
	position.y = clamp(position.y, 65, Constants.FIELD_SIZE.y - 32)


func bomb():
	if Input.is_action_just_pressed("bomb"):
		if bombs:
			root.shake_frames = 60 * 5
			root.shake_intensity = 32
			bomb_sound.play()
			bombs -= 1
			got_hit = false
			Bullets.clear_screen_fade(position, 192, true)
			$bombtemp/AnimationPlayer.play("New Anim")
			i_frame_timer = bomb_iframes
			
			
func shoot():
	if Input.is_action_just_pressed("shoot") && false:
		for s in shooters_focus[power]:
			s.fire_timer = s.fire_rate + s.start_delay
		for s in shooters_unfocus[power]:
			s.fire_timer = s.fire_rate + s.start_delay

	if Input.is_action_pressed("shoot"):
		var shooters = shooters_focus[power] if focused else shooters_unfocus[power]
		for s in shooters:
			s.fire_timer -= 1
			if s.fire_timer <= 0:
				s.fire_timer = s.fire_rate
				
				var shot = Shot.instance()
				var direction = Vector2(1, 0).rotated(s.angle)
				shot.direction = direction
				shot.angle = s.angle
				shot.rotation = s.angle
				shot.speed = s.speed
				shot.accel = s.accel
				shot.max_speed = s.max_speed
				shot.damage = s.damage
				shot.radial_homing = s.radial_homing
				shot.lateral_homing = s.lateral_homing
				
				var option_pos = Vector2(0,0)
				if s.option != -1:
					option_pos = option_positions_unfocus[power-1][s.option] * (1 - option_interp) + option_positions_focus[power-1][s.option] * option_interp
				
				if s.stationary_piercing:
					shot.piercing = true
					shot.limited_life = true
					shot.life_time = s.fire_rate
					shot.life_timer = s.fire_rate
					shot.position = s.offset + option_pos + Vector2(512, 0).rotated(s.angle)
					add_child(shot)
					shot.collision_box.get_node("CollisionShape2D").shape.extents = Vector2(512, 512)
				else:
					shot.position = position + s.offset + option_pos
					root.add_child(shot)
					shot.collision_box.get_node("CollisionShape2D").shape.extents = s.hitbox
					
				#print(option_pos)
				if s.laser_animated:
					shot.laser_animation = true
					shot.sprite.region_enabled = true
					shot.sprite.region_rect = Rect2(0, 0, 512, 16)
				
				shot.sprite.texture = s.sprite
				if s.blend == 1:
					shot.sprite.modulate = Color(1, 1, 1, 0.5)
					shot.sprite.material = add_material
				if s.blend == 2:
					shot.sprite.material = add_material
				
func _process(delta):
	var last_position = position
	hitbox1.rotation += 2.0 * delta
	hitbox2.rotation -= 2.0 * delta
	
	var left_pressed = Input.is_action_pressed("left") 
	var right_pressed = Input.is_action_pressed("right") 
	
	anim_timer += delta
	if anim_timer >= anim_time:
		anim_frame += 1
		anim_timer -= anim_time	
	if anim_frame >= 120:
		anim_frame -= 120
	
	if !left_pressed && !right_pressed:
		Sprite.frame = int(anim_frame) % 4
	elif left_pressed:
		facing = -1
		Sprite.frame = 4 + int(anim_frame) % 4
	else:
		facing = 1
		Sprite.frame = 4 + int(anim_frame) % 4
	
	Sprite.scale.x = facing * 0.75
	
	for i in 4:
		option_sprites[i].visible = i <= power-1
		option_sprites[i].rotation -= 2.0 * delta
	for i in power:
		option_sprites[i].position = option_positions_unfocus[power-1][i] * (1 - option_interp) + option_positions_focus[power-1][i] * option_interp
	
	if focused && option_interp < 1.0:
		option_interp += option_travel_speed
		if option_interp > 1.0:
			option_interp = 1.0
	elif !focused && option_interp > 0.0:
		option_interp -= option_travel_speed
		if option_interp < 0.0:
			option_interp = 0.0
	death_effect.material.set_shader_param("position", position)
	
	if dead:
		death_wave_radius += 32.0
		death_effect.material.set_shader_param("radius", max(0, death_wave_radius))
		Bullets.clear_screen_fade(position, max(0, death_wave_radius), false)
		
	# option smoothing, looks bad though
	#for i in range(len(prev_pos)-1, 0, -1):
	#	prev_pos[i] = prev_pos[i-1]
	#prev_pos[0] = position
	
	if !got_hit:
		move()
		if !root.dialogue:
			shoot()
		if position.y < 350:
			Bullets.poc_items()
		if i_frame_timer > 0:
			i_frame_timer -= 1
			Sprite.modulate = Color(0, 0, 1) if (i_frame_timer / 6) % 2 == 1 else Color(1,1,1)
		check_collision()
		
		
	else:
		deathbomb_timer -= 1
		if deathbomb_timer <= 0:
			dead = true
			Sprite.hide()
			if !respawning:
				lives -= 1
				#power_decimal -= 50
				bombs = 3
				death_wave_radius = -300
				respawn_timer = respawn_time
				respawning = true
			
	while power_decimal >= 100:
		$powerup.play()
		power += 1
		power_decimal -= 100
	while power_decimal < 0:
		power -= 1
		power_decimal += 100
	if power >= 4:
		power = 4
		power_decimal = 0
	if power < 1:
		power = 1
		power_decimal = 0
			
	if !dead:
		pass
		#bomb()
	else:
		if respawn_timer > 0:
			respawn_timer -= 1
			if respawn_timer <= 0:
				respawn_timer = 0
				Sprite.show()
				dead = false
				got_hit = false
				respawning = false
				death_effect.material.set_shader_param("radius", 0)
				position = Vector2(500, 900)
				i_frame_timer = respawn_iframes
	
	for i in range(0):
		if Input.is_action_just_pressed("debug_" + str(i) + "p"):
			power = i
	
	
	graze_particles.process_material.trail_divisor = 360 / (graze_this_frame * 10) if graze_this_frame > 0 else 9999
	
	#$options.position += last_position - position
	$options.position = lerp($options.position + last_position - position, Vector2(0,0), 0.25)
	
	Sprite.material.set_shader_param("direction", facing)
	Sprite.material.set_shader_param("frame", Sprite.frame)
	
	#Sprite.rotation = randf()*TAU
