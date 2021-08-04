extends Node2D

const UV_PIXEL = Vector2(1.0/512.0, 1.0/1024.0)

onready var bullet_texture = preload("res://bullet/bullet.png")
onready var mix_material = preload('res://bullet/mix.tres')
onready var add_material = preload('res://bullet/add.tres')
onready var sub_material = preload('res://bullet/sub.tres')
onready var mul_material = preload('res://bullet/mult.tres')

onready var root = get_parent()
onready var player = get_node('../player')

onready var Bullet = preload("res://Bullet.gdns")
onready var CurveLaser = preload("res://CurveLaser.gdns")
onready var Item = preload("res://Item.gdns")

enum ITEM {POWER_LARGE, LIFE_FRAGMENT, LIFE, BOMB_FRAGMENT, BOMB, FULL, POWER, POINT, PIV, LENGTH}

enum TRANSFORM {NORMAL, AUTO_DELETE, DELETE, GRAVITY, BOUNCE, WARP, LAYER, XY, AT_PLAYER, ROTATE}

#enum TRANSFORM_COND {TIME, OFF_BY_ONE_BUFFER_LOL_DONT_USE_THIS, GRAZE, BOUNCE, WARP}
const TRANSFORM_COND = {
	TIME = 0,
	GRAZE = -2,
	BOUNCE = -3,
	WARP = -4
}

var fast_forward = false
var fast_forward_frame_skip_timer = 0
const FAST_FORWARD_FRAME_SKIP_TIME = 12


onready var BulletRenderer = get_node("../BulletRenderer")
onready var BulletManager = get_node("../BulletManager")
onready var BulletRendererUpper = get_node("../BulletRendererUpper")
onready var BulletRendererAdd = get_node("../BulletRendererAdd")
onready var BulletClear = get_node("../BulletClear")
onready var ItemRenderer = get_node("../ItemRenderer")
onready var ItemTextRenderer = get_node("../ItemText")

func _ready():
	Globals.Bullets = self
	for _i in range(4096):
		var new_bullet = Bullet.new()
		free_bullets.append(new_bullet)
	for _i in range(4096):
		var new_item = Item.new()
		reset_item(new_item)
		free_items.append(new_item)
		
	
var curve_lasers = []
var loose_lasers = []
var straight_lasers = []
var active_bullets = []
var free_bullets = []
var clearing_bullets = []
var free_items = []
var active_items = []
var collected_items = []

# TODO: add fade functionality
func create_curve_laser(position: Vector2, speed, angle, length, width, accel, max_speed, type, colour, _fade=true, w_vel = 0.0, blend=BLEND_MODE_MIX, sample_rate=2):
	var laser = CurveLaser.new()
	laser.free = false
	
	laser.sample_rate = sample_rate
	laser.speed = speed
	var true_angle = deg2rad(angle)
	laser.angle = true_angle
	laser.direction = Vector2(cos(true_angle), sin(true_angle))
	laser.length = length
	laser.width = width
	laser.accel = accel
	laser.max_speed = max_speed
	laser.w_vel = deg2rad(w_vel)
	
	laser.type = type
	laser.colour = colour
	
	var values = get_uvs(type, colour)
	#[offset, scale, animated, anim_step, anim_width, b_col, uv]
	laser.animated = values[2]
	laser.anim_step = values[3]
	laser.anim_width = values[4]
	laser.colour = values[5]
	laser.uv = values[6]
	
	var points = PoolVector2Array()
	var verts = PoolVector3Array()
	var uvs = PoolVector2Array()
	var bullet_length = int(min(len(free_bullets), (length * (1.0 - Constants.LASER_SIZES[type].y - Constants.LASER_SIZES[type].z)) / sample_rate))
	var uvstep = 1.0 / max(length - 1, 1)
	
	var v1 = Vector3(position.x - laser.direction.y * width*0.5, position.y + laser.direction.x * width*0.5, 0)
	var v2 = Vector3(position.x + laser.direction.y * width*0.5, position.y - laser.direction.x * width*0.5, 0)
	
	for i in range(length):
		points.append(position)
		verts.append(v1)
		verts.append(v2)
		uvs.append(Vector2(laser.uv.r, laser.uv.g + laser.uv.a * i * uvstep)) # tex_rect.position + Vector2(0, tex_rect.size.y * uv.y) 
		uvs.append(Vector2(laser.uv.r + laser.uv.b, laser.uv.g + laser.uv.a * i * uvstep)) # tex_rect.position + Vector2(0, tex_rect.size.y * uv.y) 
		
	for i in bullet_length:
		var new_bullet = free_bullets.pop_back()
		BulletManager.update_bullet(new_bullet, position, 0.0, 0.0, 0.0, 0.0, type, colour, false, 0.0, 0.0, blend, Constants.BULLET_KIND.CURVE_LASER, null, width, null)
		new_bullet.position = position
		laser.bullets.append(new_bullet)
		new_bullet.free = false
	
	laser.start_index = int(Constants.LASER_SIZES[type].y * length)
	
	laser.points = points
	laser.verts = verts
	laser.uvs = uvs
	#laser.points = points
	
	#var tst = ArrayMesh.new()
	#laser.set_mesh(tst)
	#print(laser.get_mesh())
	#print(tst)
	
	laser.mesh = ArrayMesh.new()
	
	laser.blend = blend
	
	laser.visible = true
	
	curve_lasers.append(laser)
	
	return laser


func create_bullet(position: Vector2, speed, angle, accel, max_speed, type, colour, fade=true, w_vel = 0.0, spin=0.0, blend=BLEND_MODE_MIX):
	if len(free_bullets) > 0:	
		var new_bullet = free_bullets.pop_back()
		BulletManager.update_bullet(new_bullet, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend, Constants.BULLET_KIND.BULLET, null, null)
		active_bullets.append(new_bullet)
		new_bullet.free = false
		new_bullet.layer = 0
		
		return new_bullet
	return null	

func create_loose_laser(position: Vector2, speed, angle, length, width, accel, max_speed, type, colour, fade=true, w_vel = 0.0, spin=0.0, blend=BLEND_MODE_MIX):
	if len(free_bullets) > 0:	
		var new_bullet = free_bullets.pop_back()
		BulletManager.update_bullet(new_bullet, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend, Constants.BULLET_KIND.LOOSE_LASER, length, width)
		loose_lasers.append(new_bullet)
		new_bullet.free = false
		new_bullet.layer = 0

		return new_bullet
	return null
		
func create_straight_laser(position: Vector2, angle, length, width, delay, time, type, colour, w_vel = 0.0, blend=BLEND_MODE_MIX):
	if len(free_bullets) > 0:	
		var new_bullet = free_bullets.pop_back()
		BulletManager.update_bullet(new_bullet, position, 0.0, angle, 0.0, 0.0, type, colour, false, w_vel, 0.0, blend, Constants.BULLET_KIND.STRAIGHT_LASER, length, width)
		straight_lasers.append(new_bullet)
		new_bullet.active = false
		new_bullet.laser_timer = time
		new_bullet.fade_frames = delay
		new_bullet.fade_time = 8.0
		new_bullet.free = false
		new_bullet.layer = 0
		return new_bullet
	return null
		
# Buffer of 100 so the piv items don't interfere with important items TWC Tewi style
func create_item(pos, type, fling=true, angle=-90.0, speed=24.0, auto_poc=false, up_speed=20.0):
	if len(free_items) > 100 || (len(free_items) > 0 && type != ITEM.PIV):
		var item = free_items.pop_back()
		item.type = type
		item.position = pos
		item.up_speed = up_speed
		var true_angle = deg2rad(angle)
		var direction = Vector2(cos(true_angle), sin(true_angle))
		item.direction = direction
		if !fling:
			item.angle = 0.0 
			item.spin = 0.0
		else:
			item.angle = randf()*TAU
			item.spin = 0.5 if abs(angle) > PI/2.0 else -0.5
		item.speed = speed
		if type < ITEM.POWER:
			item.poc_size *= 2.0
			item.scale *= 1.5
		active_items.append(item)
		item.poced = auto_poc
		item.max_value = auto_poc
		return item
	return null

func get_uvs(type, colour):
	var srect: Rect2
	var offset: float
	var scale = 1.0
	var tex = 1
	var animated = false
	var anim_width = 64
	var b_col = colour
	var uv = Vector2()
	var anim_step = 0.3334
	
	if type <= Constants.BULLET_TYPE.DROPLET: # Regular bullets
		srect = Rect2(16*colour, 16*type, 16, 16)
		if type == Constants.BULLET_TYPE.ARROWHEAD: # Kunai and arrowheads on spritesheet aren't centered on the tip
			offset = -6.5/32.0
		elif type == Constants.BULLET_TYPE.KUNAI: # Kunai and arrowheads on spritesheet aren't centered on the tip
			offset = 5.0/32.0
	elif type <= Constants.BULLET_TYPE.RICE_SMALL: # Popcorn and small rice
		srect = Rect2(8*(colour % 8) + 64 * (type - Constants.BULLET_TYPE.POPCORN), 192 + 8*floor(colour*0.125), 8, 8)
		scale = 0.5
	elif type == Constants.BULLET_TYPE.COIN:
		srect = Rect2(128 + 16*colour, 192, 16, 16)
	elif type == Constants.BULLET_TYPE.SNOWBALL:
		srect = Rect2(8*(colour % 8), 240 + 8*floor(colour*0.125), 8, 8)
		scale = 0.5
	# Sheet 2
	elif type <= Constants.BULLET_TYPE.DONTUSE: # Large Star to dark bacteria
		tex = 2
		scale = 2.0
		if type == Constants.BULLET_TYPE.KNIFE:
			offset = 9.0/64.0
		
		srect = Rect2(32 * colour, 32 * (type - Constants.BULLET_TYPE.STAR_LARGE), 32, 32)
	# Sheet 3 (bubbles)
	elif type == Constants.BULLET_TYPE.BUBBLE:
		tex = 3
		scale = 4.0
		srect = Rect2(64 * floor(colour / 2), 64 * (colour % 2), 64, 64)
	# Sheet 4 (special)
	elif type <= Constants.BULLET_TYPE.ICE_LARGE:
		tex = 4
		scale = 2.0
		if type == Constants.BULLET_TYPE.ARROW: # Arrows on spritesheet aren't centered on the tip
			offset = 18.0 / 64.0
		#elif type == Constants.BULLET_TYPE.REST:
		#	bullet.offset = Vector2(-1, 1)
		srect = Rect2(32 * colour, 32 * (type - Constants.BULLET_TYPE.HEART), 32, 32)
	elif type == Constants.BULLET_TYPE.FIREBALL: 
		tex = 4
		scale = 2.0
		offset = 4.0 / 64.0
		var oset = Constants.FIREBALL_OFFSETS[colour]
		srect = Rect2(4*32*oset.x, 128 + 32*oset.y, 32, 32)
		animated = true
	elif type == Constants.BULLET_TYPE.DIVINE_SPIRIT: 
		tex = 5
		scale = 4.0
		srect = Rect2(64 * (colour % 4), 64 * floor(colour / 4), 64, 64)
	# Lasers, don't use them as bullets please 
	elif type == Constants.BULLET_TYPE.LASER:
		srect = Rect2(16 * colour, 640, 16, 256)
	elif type == Constants.BULLET_TYPE.LIGHTNING:
		srect = Rect2(128, 640, 32, 256)
		animated = true
		anim_width = 32
	elif type == Constants.BULLET_TYPE.GEAR:
		srect = Rect2(256, 192, 64, 64)
		b_col = Constants.COLOURS_LARGE.GREY
		scale = 4.0
	elif type == Constants.BULLET_TYPE.SAW:
		srect = Rect2(320 + colour * 64 * (randi()%2+1), 192, 64, 64)
		scale = 4.0
	elif type == Constants.BULLET_TYPE.GEAR_SMALL:
		srect = Rect2(256, 160, 32, 32)
		b_col = Constants.COLOURS_LARGE.GREY
		scale = 2.0
	elif type == Constants.BULLET_TYPE.SAW_SMALL:
		srect = Rect2(288 + colour * 32 * (randi()%2+1), 160, 32, 32)
		scale = 2.0
	elif type == Constants.BULLET_TYPE.MONEY:
		srect = Rect2(384, 160, 32, 32)
		scale = 2.0
	elif type == Constants.BULLET_TYPE.NOTE: 
		scale = 2.0
		offset = 20.0 / 64.0
		srect = Rect2(128 * (colour % 2), 896 + 32 * (colour / 2), 32, 32)
		animated = true
		anim_step = 0.08334
	
	scale *= 40.0
	
	match tex:
		2:
				srect.position.x += 256
		3:
			srect.position.y += 256
		4:
			srect.position += Vector2(256, 256)
		5:
			srect.position.y += 256 + 128
	
	uv = Color(srect.position.x * UV_PIXEL.x, srect.position.y * UV_PIXEL.y, srect.size.x * UV_PIXEL.x, srect.size.y * UV_PIXEL.y)
	
	
	return [offset, scale, animated, anim_step, anim_width, b_col, uv]


# Ok so uh for some reason the draw rect is called srect and the source rect is called texture_rect and I can't be bothered to fix it now
# whatever you shouldn't even be touching them anyways

func update_bullet(bullet, position = null, speed = null, angle = null, accel = null, max_speed = null, type_want = null, colour_want = null, fade=true, w_vel = null, spin=null, blend=null, laser=null, laser_length=null, laser_width=null):
	BulletManager.update_bullet(bullet, position, speed, angle, accel, max_speed, type_want, colour_want, fade, w_vel, spin, blend, laser, laser_length, laser_width)

func update_bullet_old(bullet, position = null, speed = null, angle = null, accel = null, max_speed = null, type_want = null, colour_want = null, fade=true, w_vel = 0.0, spin=0.0, blend=BLEND_MODE_MIX, laser=null, laser_length=10.0, laser_width=2.0):
	if position != null:
		bullet.position = position
	
	# Update bullet data if they aren't null
	if speed != null:
		bullet.speed = speed
	if angle != null:
		var true_angle = deg2rad(angle)
		bullet.angle = true_angle
		bullet.sprite_angle = true_angle
		bullet.direction = Vector2(cos(true_angle), sin(true_angle))
	if accel != null:
		bullet.accel = accel
	if max_speed != null:
		bullet.max_speed = max_speed
	if w_vel != null:
		bullet.w_vel = deg2rad(w_vel)
	if spin != null:
		bullet.spin = spin
	
	if blend != null:
		bullet.blend = blend
	
	# If either the type, colour, or laser type is set to update, do so
	if type_want != null || colour_want != null || laser != null:
		var type = bullet.type
		if type_want != null: 
			type = type_want
			bullet.type = type
		var colour = bullet.colour
		if colour_want != null: 
			colour = colour_want
			bullet.colour = colour
		
		bullet.no_rotate = type in Constants.NO_ROTATE_BULLETS
		bullet.animated = false
		bullet.collision_type = laser
		
		#[offset, scale, animated, anim_step, anim_width, b_col, uv]
		var values = BulletManager.get_uvs(type, colour)#get_uvs(type, colour)
		bullet.offset = values[0]
		bullet.scale = values[1]
		bullet.animated = values[2]
		bullet.anim_step = values[3]
		bullet.anim_width = values[4]
		bullet.colour = values[5]
		bullet.uv = values[6]
		
		var laser_spawn_uv = Constants.LASER_SPAWN_UV
		laser_spawn_uv.r += laser_spawn_uv.b * get_large_colour(bullet)
		bullet.laser_spawn_uv = laser_spawn_uv
		
		bullet.size = Constants.BULLET_SIZES[type] if laser == Constants.BULLET_KIND.BULLET else (Constants.LASER_SIZES[type].x * laser_width * 0.5)
		
		if laser == Constants.BULLET_KIND.LOOSE_LASER:
			bullet.collision_type = Constants.BULLET_KIND.LOOSE_LASER
			#srect = Rect2(-laser_width*0.5, 0.0, laser_width, laser_length)
			bullet.length = laser_length
			bullet.width = laser_width
			bullet.scale = laser_width
			bullet.clearance_front = Constants.LASER_SIZES[type].y
			bullet.clearance_back = Constants.LASER_SIZES[type].z
		elif laser == Constants.BULLET_KIND.STRAIGHT_LASER:
			bullet.collision_type = Constants.BULLET_KIND.STRAIGHT_LASER
			#srect = Rect2(-laser_width*0.5, -laser_length, laser_width, laser_length)
			bullet.length = laser_length
			bullet.width = laser_width
			bullet.scale = laser_width
			bullet.clearance_front = Constants.LASER_SIZES[type].y
			bullet.clearance_back = Constants.LASER_SIZES[type].z
		elif laser == Constants.BULLET_KIND.CURVE_LASER:
			pass
			#bullet.size *= 0.5
		else:
			bullet.collision_type = Constants.BULLET_KIND.BULLET	
		
		if bullet.animated:
			bullet.anim_frame = randi()%bullet.anim_frame_max
		
	
	if laser != Constants.BULLET_KIND.CURVE_LASER:
		if fade:
			if laser == Constants.BULLET_KIND.BULLET:
				bullet.fade_time = bullet.BULLET_FADE_TIME
			elif laser == Constants.BULLET_KIND.LOOSE_LASER:
				bullet.fade_time = int(laser_length / speed)
			bullet.fade_frames = bullet.fade_time
			bullet.active = false
		else:
			bullet.active = true


func set_gravity(bullet, gravity: Vector2, max_speed: Vector2):
	if bullet:
		bullet.acc_vector = gravity
		bullet.vel_max_vector = max_speed

func set_layer(bullet, layer):
	if bullet:
		bullet.layer = layer

func set_xy(bullet, x, y):
	if bullet:
		if x != null:
			bullet.position.x = x
		if y != null:
			bullet.position.y = y

func aim_at_player(bullet):
	if bullet:
		var angle = player.position.angle_to_point(bullet.position)
		#bullet, position, speed, angle, accel, max_speed, type_want, colour_want, fade, w_vel, spin, blend, laser, laser_length, laser_width
		BulletManager.update_bullet(bullet, null, null, rad2deg(angle), null, null, null, null, null, null, null, null, null, null, null)

func aim_laser_at_player(laser):
	if laser:
		var angle = player.position.angle_to_point(laser.points[0])
		BulletManager.update_curve_laser(laser, null, null, rad2deg(angle))
		
		#update_bullet(laser, null, null, rad2deg(angle))


func offset_angle(bullet, oset: float):
	if bullet:
		BulletManager.offset_angle(bullet, oset)
		#BulletManager.update_bullet(bullet, null, null, rad2deg(bullet.angle) + oset)


# angle: "at player"
func queue_update_bullet(bullet, time: int, position = null, speed = null, angle = null, accel = null, max_speed = null, type = null, colour = null, fade=false, w_vel = null, spin=null, blend=null):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.NORMAL, position, speed, angle, accel, max_speed, type, colour, fade == true, w_vel, spin, blend, null, null, null])

func set_autodelete(bullet, enable: bool):
	if bullet:
		bullet.auto_delete = enable

func free_bullet(bullet):
	if bullet:
		bullet.free = true

func queue_autodelete(bullet, time: int, enable: bool):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.AUTO_DELETE, enable])

func queue_delete(bullet, time: int):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.DELETE])

func queue_set_gravity(bullet, time: int,  gravity: Vector2, max_speed: Vector2):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.GRAVITY, gravity, max_speed])

func queue_set_xy(bullet, time:int, x: float, y: float):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.XY, x, y])
		
func queue_aim_at_player(bullet, time:int):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.AT_PLAYER])
		
func queue_rotate(bullet, time:int, phi: float):
	if bullet:
		bullet.transform_queue.append([time, TRANSFORM.ROTATE, phi])
		
func queue_offset_angle(bullet, time:int, phi: float):
	queue_rotate(bullet, time, phi)

# TODO: Add type change support if I feel like it
func update_curve_laser(laser, position = null, speed = null, angle = null, accel = null, max_speed = null, _type = null, _colour = null, _fade=false, w_vel = null, _blend=null):
	if position != null:
		laser.position = position
	
	# Update bullet data if they aren't null
	if speed != null:
		laser.speed = speed
	if angle != null:
		var true_angle = deg2rad(angle)
		laser.angle = true_angle
#		laser.sprite_angle = true_angle
		laser.direction = Vector2(cos(true_angle), sin(true_angle))
	if accel != null:
		laser.accel = accel
	if max_speed != null:
		laser.max_speed = max_speed
	if w_vel != null:
		laser.w_vel = deg2rad(w_vel)
	

func queue_update_curve_laser(laser, time: int, position = null, speed = null, angle = null, accel = null, max_speed = null, type = null, colour = null, fade=false, w_vel = null, blend=null):
	laser.transform_queue.append([time, TRANSFORM.NORMAL, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, blend])


func clear_offscreen_bullets():
	for b in active_bullets:
		var dist = 50.0 if !b.bounce_count && b.warp_count else 100.0
		var clear_rect = Rect2(Vector2(-dist, -dist), Constants.FIELD_SIZE + Vector2(2.0*dist, 2.0*dist))
		if b.auto_delete && !clear_rect.has_point(b.position):
			b.visible = false
			b.free = true
			
			
	for b in loose_lasers:
		if b.auto_delete:
			var bounding_box = Rect2(b.position, -b.direction * b.length)
			if bounding_box.size.x < 0:
				bounding_box.position.x += bounding_box.size.x
				bounding_box.size.x *= -1
			if bounding_box.size.y < 0:
				bounding_box.position.y += bounding_box.size.y
				bounding_box.size.y *= -1
			if !Constants.CLEAR_RECT.intersects(bounding_box):
				b.visible = false
				b.free = true
	
	for l in curve_lasers:
		var all_outside = true
		for b in l.bullets:
			if Constants.CLEAR_RECT.has_point(b.position):
				all_outside = false
				break
		if all_outside:
			l.free = true
			for b in l.bullets:
				b.visible = false
				b.free = true
				b.collision_type = Constants.BULLET_KIND.BULLET
				
	for b in active_items:
		if b.position.y > 1128:
			b.free = true

func reset_bullet(b):
	b.bounce_count = 0
	b.bounce_bottom = false
	b.bounce_top = true
	b.bounce_left = true
	b.bounce_right = true
	
	b.warp_count = 0
	b.warp_bottom = false
	b.warp_top = false
	b.warp_left = true
	b.warp_right = true
	
	b.grazed = false
	b.already_grazed = false
	b.graze_frame = 0
	
	b.acc_vector = Vector2(0,0)
	b.vel_max_vector = Vector2(0,0)
	b.auto_delete = true
	b.offset = 0.0
	b.layer = 0
	b.anim_step = 0.3334
	
	b.transform_queue.clear()
	b.variables.clear()
	
	b.active = true
	b.visible = true
	
	b.fade_frames = 0.0
	b.fade_time = 8.0
	b.fade_clear = true
	b.laser_complete = false
	
func reset_item(b):
	b.position = Vector2()
	b.angle = 0.0
	b.direction = Vector2()
	b.speed = 2.0
	b.up_speed = 24.0
	b.spawn_timer = 45
	b.poced = false
	b.free = false
	b.type = 0.0
	b.size = 64.0
	b.poc_size = 128.0
	b.scale = 64.0
	
	b.collect_timer = 0.0

func poc_items():
	for i in active_items:
		i.poced = true
		i.max_value = true
	
func get_large_colour(b):
	var c = b.colour
	if b.type in Constants.SMALL_BULLETS:
		c = Constants.small2largecolour(c)
	elif b.type == Constants.BULLET_TYPE.LIGHTNING:
		c = Constants.COLOURS_LARGE.BLUE
	elif b.type == Constants.BULLET_TYPE.DIVINE_SPIRIT:
		c = Constants.divine2largecolour(c)
	elif b.type == Constants.BULLET_TYPE.NOTE:
		c = Constants.note2largecolour(c)
	elif b.type == Constants.BULLET_TYPE.COIN:
		c = Constants.coin2largecolour(c)
	elif b.type == Constants.BULLET_TYPE.GEAR || b.type == Constants.BULLET_TYPE.SAW || b.type == Constants.BULLET_TYPE.GEAR_SMALL || b.type == Constants.BULLET_TYPE.SAW_SMALL:
		c = Constants.COLOURS_LARGE.GREY
	elif b.type == Constants.BULLET_TYPE.MONEY:
		c = Constants.COLOURS_LARGE.GREEN
	return c

func fade_bullet(b):
	clearing_bullets.append(b)
	b.clear_timer = b.CLEAR_TIME
	b.fade_position = b.position
	b.fade_angle = randf()*360.0
	b.fade_angle2 = randf()*360.0
	b.fade_lr = 1 if randi()%2 == 0 else -1
	b.fade_scale = b.scale*0.5 + 32#sqrt(b.scale) * 16
	var c = get_large_colour(b)
	var cv = Constants.COLOUR_VALUES[-1] if c >= len(Constants.COLOUR_VALUES) else Constants.COLOUR_VALUES[c]
	b.fade_colour = cv

func clear_bullets():
	var layer = 0
	var j = 0
	for i in range(len(active_bullets)):
		var b = active_bullets[i]
		if !b.free:
			layer += 1
			
			active_bullets[j] = b
			j += 1
			
		else:
			free_bullets.append(b)
			if b.fade_clear && b.visible:
				fade_bullet(b)
			b.fade_clear = true
			reset_bullet(b)
			
	active_bullets.resize(j)
	
	layer = 0
	j = 0
	for i in range(len(loose_lasers)):
		var b = loose_lasers[i]
		if !b.free:
			layer += 1
				
			loose_lasers[j] = b
			j += 1
		else:
			free_bullets.append(b)
			if b.fade_clear && b.visible:
				fade_bullet(b)
			b.fade_clear = true
			reset_bullet(b)
	
	loose_lasers.resize(j)
	
	layer = 0
	j = 0
	for i in range(len(straight_lasers)):
		var b = straight_lasers[i]
		if !b.free:
			layer += 1
			
			straight_lasers[j] = b
			j += 1
				
		else:
			free_bullets.append(b)
			if b.fade_clear && b.visible:
				fade_bullet(b)
			b.fade_clear = true
			reset_bullet(b)
				
	straight_lasers.resize(j)

	layer = 0
	j = 0
	for i in range(len(curve_lasers)):
		var l = curve_lasers[i]
		l.acc_vector = Vector2(0,0)
		l.vel_max_vector = Vector2(0,0)
		if !l.free:
			layer += 1
			
			curve_lasers[j] = l
			j += 1
				
		else:
			
			
			for b in l.bullets:
				free_bullets.append(b)
				if b.fade_clear && b.visible:
					fade_bullet(b)
				b.fade_clear = true
				reset_bullet(b)
			#l.queue_free()

	curve_lasers.resize(j)
	
	j = 0
	for i in range(len(clearing_bullets)):
		var b = clearing_bullets[i]
		if b.clear_timer > 0:
			layer += 1
			clearing_bullets[j] = b
			j += 1
			b.clear_timer -= 0.25
			
	clearing_bullets.resize(j)
	
	j = 0
	for i in range(len(active_items)):
		var b = active_items[i]
		if !b.free:
			
			active_items[j] = b
			j += 1
			
		else:
			free_items.append(b)
			if b.point > 0.0:
				collected_items.append(b)
			reset_item(b)
			
	active_items.resize(j)
	
	j = 0
	for i in range(len(collected_items)):
		var b = collected_items[i]
		if b.collect_timer < 1.0:
			collected_items[j] = b
			j += 1
			b.collect_timer += 0.05
		else:
			b.point = 0.0
			b.max_value_float = 0.0
			
	collected_items.resize(j)
	
func transform_bullet(b, t):
	match t[1]:
		TRANSFORM.NORMAL:
			BulletManager.update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14])
		TRANSFORM.AUTO_DELETE:
			set_autodelete(b, t[2])
		TRANSFORM.DELETE:
			free_bullet(b)
		TRANSFORM.GRAVITY:
			set_gravity(b, t[2], t[3])
		TRANSFORM.XY:
			set_xy(b, t[2], t[3])
		TRANSFORM.LAYER:
			set_layer(b, t[2])
		TRANSFORM.AT_PLAYER:
			aim_at_player(b)
		TRANSFORM.ROTATE:
			offset_angle(b, t[2])
		
func transform_curve_laser(b, t):
	match t[1]:
		TRANSFORM.NORMAL:
			update_curve_laser(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11])
		TRANSFORM.AUTO_DELETE:
			set_autodelete(b, t[2])
		TRANSFORM.DELETE:
			free_bullet(b)
		TRANSFORM.GRAVITY:
			set_gravity(b, t[2], t[3])
		TRANSFORM.XY:
			set_xy(b, t[2], t[3])
		TRANSFORM.LAYER:
			set_layer(b, t[2])
		TRANSFORM.AT_PLAYER:
			aim_laser_at_player(b)
		TRANSFORM.ROTATE:
			offset_angle(b, t[2])
		
	
	
func move_bullets():
	#var angle = (Constants.FIELD_SIZE*0.5 + p).angle_to_point(player.position) + PI
	
	BulletManager.move_bullets()
		
	for b in loose_lasers:
		if !b.free:
			if b.fade_frames > 0:
				b.fade_frames -= 1
				if b.fade_frames <= b.fade_time - 6:
					b.active = true
							
			if b.w_vel != 0:
				b.angle += b.w_vel
				b.sprite_angle += b.w_vel
				b.direction = Vector2(cos(b.angle), sin(b.angle))
			
			if b.accel && b.speed != b.max_speed:
				b.speed += b.accel
				if (b.accel < 0 && b.speed < b.max_speed) || (b.accel > 0 && b.speed > b.max_speed):
					b.speed = b.max_speed
			
			b.position += b.direction * b.speed
			b.sprite_angle += b.spin
			
			var i = 0
			var j = 0
			var loop_times = len(b.transform_queue)
			while i < loop_times:
				b.transform_queue[j] = b.transform_queue[i]
		# warning-ignore:shadowed_variable
				var t = b.transform_queue[j]
				match t[0]:
					0, -1:
						transform_bullet(b, t)
								#update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#[time, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend]
					TRANSFORM_COND.BOUNCE:
						#if bounced:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.WARP:
						#if warped:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.GRAZE:
						if b.grazed && !b.already_grazed:
							transform_bullet(b, t)
						else:
							j += 1
					_:
						t[0] -= 1
						j += 1
				if b.grazed:
					b.already_grazed = true
				i += 1
							
	for b in straight_lasers:
		if !b.free:
			
			if b.fade_frames > -18:
				b.fade_frames -= 1
				if !b.laser_complete && b.fade_frames <= -15:
					b.active = true
			
			if b.fade_frames <= 0:
				b.laser_timer -= 1
				if b.laser_complete:
					b.free = true
					b.fade_clear = false
			
			if b.laser_timer <= 15:
				b.active = false
			
			if b.laser_timer == 0:
				b.laser_timer = -1
				b.laser_complete = true
				b.fade_frames = b.fade_time
			
			if b.w_vel != 0:
				b.angle += b.w_vel
				b.direction = Vector2(cos(b.angle), sin(b.angle))
			
			var i = 0
			var j = 0
			var loop_times = len(b.transform_queue)
			while i < loop_times:
				b.transform_queue[j] = b.transform_queue[i]
		# warning-ignore:shadowed_variable
				var t = b.transform_queue[j]
				match t[0]:
					0, -1:
						transform_bullet(b, t)
								#update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#[time, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend]
					TRANSFORM_COND.BOUNCE:
						#if bounced:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.WARP:
						#if warped:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.GRAZE:
						if b.grazed && !b.already_grazed:
							transform_bullet(b, t)
						else:
							j += 1
					_:
						t[0] -= 1
						j += 1
				if b.grazed:
					b.already_grazed = true
				i += 1
			for _a in range(i-j):
				b.transform_queue.pop_back()
		
	for b in curve_lasers:
		if !b.free:
			if b.w_vel != 0:
				b.angle += b.w_vel
				b.direction = Vector2(cos(b.angle), sin(b.angle))
			
			if b.accel && b.speed != b.max_speed:
				b.speed += b.accel
				if (b.accel < 0 && b.speed < b.max_speed) || (b.accel > 0 && b.speed > b.max_speed):
					b.speed = b.max_speed
			
			var points = PoolVector2Array()
			var verts = PoolVector3Array()
			
			points.append(b.points[0] + b.direction * b.speed)
			verts.append(Vector3(points[0].x - b.direction.y * b.width*0.5, points[0].y + b.direction.x * b.width*0.5, 0))
			verts.append(Vector3(points[0].x + b.direction.y * b.width*0.5, points[0].y - b.direction.x * b.width*0.5, 0))
			
			points.append_array(b.points)
			verts.append_array(b.verts)
			points.resize(b.points.size())
			verts.resize(b.verts.size())
			b.points = points
			b.verts = verts
			
			for i in range(len(b.bullets)):
				b.bullets[i].position = b.points[b.start_index+i*b.sample_rate]
				b.bullets[i].direction = (b.points[b.start_index+(i+1)*b.sample_rate] - b.bullets[i].position).normalized()
				
			
			
			var i = 0
			var j = 0
			var loop_times = len(b.transform_queue)
			while i < loop_times:
				b.transform_queue[j] = b.transform_queue[i]
		# warning-ignore:shadowed_variable
				var t = b.transform_queue[j]
				match t[0]:
					0, -1:
						transform_curve_laser(b, t)
								#update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#[time, position, speed, angle, accel, max_speed, type, colour, fade, w_vel, spin, blend]
					TRANSFORM_COND.BOUNCE:
						#if bounced:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.WARP:
						#if warped:
						#	match t[1]:
						#		TRANSFORM.NORMAL:
						#			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12])
						#		TRANSFORM.AUTO_DELETE:
						#			b.auto_delete = t[2]
						#		TRANSFORM.DELETE:
						#			b.free = true
						#		TRANSFORM.GRAVITY:
						#			set_gravity(b, t[2], t[3])
						#else:
						#	j += 1
						pass
					TRANSFORM_COND.GRAZE:
						if b.grazed && !b.already_grazed:
							transform_curve_laser(b, t)
						else:
							j += 1
					_:
						t[0] -= 1
						j += 1
				if b.grazed:
					b.already_grazed = true
				i += 1
			for _a in range(i-j):
				b.transform_queue.pop_back()
	
	for b in active_items:
		b.position += b.direction * b.speed
		b.position.x = clamp(b.position.x, 0.0, 1000.0)
		b.position.y -= b.up_speed
		b.spawn_timer -= 1
		if b.spawn_timer > 0:
			b.up_speed *= b.DAMP
			b.speed *= b.DAMP
			b.angle += b.spin
		elif b.spawn_timer == 0:
			b.spawn_timer -= 1
			b.up_speed = 0.0
			b.speed = 4.0
			b.angle = 0.0
			b.direction = Vector2(0.0, 1.0)
		if b.spawn_timer <= 0 && b.poced:
			b.direction = (player.position - b.position).normalized()
			if b.speed < 32.0:
				b.speed += 1.0
	
func player_collision(pos, r1, r2, focused):
	var data = BulletManager.player_collision(pos, r1, r2, focused, root.piv)
	root.graze += data[1]
	return data
	
	
func player_collision_old(pos, r1, r2, focused):
	var hit = false
	var graze = 0
	
	var items_collected = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	
	for b in active_bullets:
		if !b.active:
			continue
		if !hit && pos.distance_squared_to(b.position) < (r1 + b.size) * (r1 + b.size):
			b.hit()
			hit = true
		if !b.grazed && pos.distance_squared_to(b.position) < (r2 + b.size) * (r2 + b.size):
			b.grazed = true
			graze += 1
			root.graze += 1
					
	for b in loose_lasers:
		if !b.active:
			continue
		var p1 = b.position
		var p2 = p1 - b.direction * b.length
		var min_x = p1.x + (p2.x - p1.x) * b.clearance_front
		var max_x = p1.x + (p2.x - p1.x) * (1.0-b.clearance_back - max(float(b.fade_frames-1) / b.fade_time, 0.0))
		if min_x > max_x:
			var temp = min_x
			min_x = max_x
			max_x = temp
		min_x -= (b.size + r2) * abs(b.direction.y)
		max_x += (b.size + r2) * abs(b.direction.y)
		if pos.x < min_x || pos.x > max_x:
			continue
	
		var min_y = p1.y + (p2.y - p1.y) * b.clearance_front
		var max_y = p1.y + (p2.y - p1.y) * (1.0-b.clearance_back - max(float(b.fade_frames-1) / b.fade_time, 0.0))
		if min_y > max_y:
			var temp = min_y
			min_y = max_y
			max_y = temp
		min_y -= (b.size + r2) * abs(b.direction.x)
		max_y += (b.size + r2) * abs(b.direction.x)
		
		if pos.y < min_y || pos.y > max_y:
			continue
		
		
		var numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y)
		var dist_squared = numerator * numerator / p1.distance_squared_to(p2)
		
		if !hit && dist_squared < (r1 + b.size) * (r1 + b.size):
			b.hit()
			hit = true
		if dist_squared < (r2 + b.size) * (r2 + b.size):
			#b.grazed = true
			b.graze_frame -= 1
			if b.graze_frame <= 0:
				b.graze_frame = b.GRAZE_TIME
				graze += 1
				root.graze += 1
				
	for b in straight_lasers:
		if !b.active:
			continue
		var p1 = b.position
		var p2 = p1 + b.direction * b.length
		var min_x = p1.x + (p2.x - p1.x) * b.clearance_front
		var max_x = p1.x + (p2.x - p1.x) * (1.0-b.clearance_back)
		if min_x > max_x:
			var temp = min_x
			min_x = max_x
			max_x = temp
		var x_margin_graze = (b.size + r2) * abs(b.direction.y)
		if pos.x < (min_x - x_margin_graze) || pos.x > (max_x + x_margin_graze):
			continue
		#min_x -= (b.size + r2) * abs(b.direction.y)
		#max_x += (b.size + r2) * abs(b.direction.y)
		#if pos.x < min_x || pos.x > max_x:
		#	continue
	
		var min_y = p1.y + (p2.y - p1.y) * b.clearance_front
		var max_y = p1.y + (p2.y - p1.y) * (1.0-b.clearance_back)
		if min_y > max_y:
			var temp = min_y
			min_y = max_y
			max_y = temp
		var y_margin_graze = (b.size + r2) * abs(b.direction.x)
		if pos.y < (min_y - y_margin_graze) || pos.y > (max_y + y_margin_graze):
			continue
		#min_y -= (b.size + r2) * abs(b.direction.x)
		#max_y += (b.size + r2) * abs(b.direction.x)
		#if pos.y < min_y || pos.y > max_y:
		#	continue
		
		var x_margin = (b.size + r1) * abs(b.direction.y)
		var y_margin = (b.size + r1) * abs(b.direction.x)
		
		var numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y)
		var dist_squared = numerator * numerator / p1.distance_squared_to(p2)
		

		if !hit && pos.x > (min_x - x_margin) && pos.x < (max_x + x_margin) && pos.y > (min_y - y_margin) && pos.y < (max_y + y_margin) && dist_squared < (r1 + b.size) * (r1 + b.size):
			b.hit()
			hit = true
		if dist_squared < (r2 + b.size) * (r2 + b.size):
			b.grazed = true
			b.graze_frame -= 1
			if b.graze_frame <= 0:
				b.graze_frame = b.GRAZE_TIME
				graze += 1
				root.graze += 1

	for l in curve_lasers:
		for i in len(l.bullets)-1:
			var b = l.bullets[i]
			var p1 = b.position
			var p2 = l.bullets[i+1].position
			
			if p1 == p2:
				continue
			
			var min_x = p1.x
			var max_x = p2.x
			if min_x > max_x:
				var temp = min_x
				min_x = max_x
				max_x = temp
			#min_x -= (b.size + r2) * abs(b.direction.y)
			#max_x += (b.size + r2) * abs(b.direction.y)
			var x_margin_graze = (b.size + r2) * abs(b.direction.y)
			if pos.x < (min_x - x_margin_graze) || pos.x > (max_x + x_margin_graze):
				continue
		
			var min_y = p1.y
			var max_y = p2.y
			if min_y > max_y:
				var temp = min_y
				min_y = max_y
				max_y = temp
			#min_y -= (b.size + r2) * abs(b.direction.x)
			#max_y += (b.size + r2) * abs(b.direction.x)
			var y_margin_graze = (b.size + r2) * abs(b.direction.x)
			if pos.y < (min_y - y_margin_graze) || pos.y > (max_y + y_margin_graze):
				continue
			
			var x_margin = (b.size + r1) * abs(b.direction.y)
			var y_margin = (b.size + r1) * abs(b.direction.x)
			
			var numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y)
			var dist_squared = numerator * numerator / p1.distance_squared_to(p2)
			
			if !hit && pos.x > (min_x - x_margin) && pos.x < (max_x + x_margin) && pos.y > (min_y - y_margin) && pos.y < (max_y + y_margin) && dist_squared < (r1 + b.size) * (r1 + b.size):
				b.hit()
				hit = true
			if !b.grazed && dist_squared < (r2 + b.size) * (r2 + b.size):
				l.grazed = true
				b.grazed = true
				#graze()
				graze += 1
				root.graze += 1
	
	for i in active_items:
		if pos.distance_squared_to(i.position) < (r1 + i.size) * (r1 + i.size):
			i.free = true
			items_collected[i.type] += 1
			i.collect_position = i.position
			if i.type == ITEM.POINT:
				i.point = root.piv if i.max_value || pos.y < 350.0 else 10.0 * floor(0.1 * root.piv * ((pos.y - 350.0) / -1300.0 + 1.0))
				i.max_value_float = 1.0 if i.max_value || pos.y < 350.0 else 0.0
				
		if focused && pos.distance_squared_to(i.position) < (r2 + i.poc_size) * (r2 + i.poc_size):
			i.poced = true
	
	return [hit, graze, items_collected]


func clear_screen():
	for b in active_bullets:
		b.free = true
	for l in loose_lasers:
		l.free = true
	for l in straight_lasers:
		l.free = true
	for l in curve_lasers:
		l.free = true
		
func deactivate_screen():
	for b in active_bullets:
		b.active = false
	for l in loose_lasers:
		l.active = false
	for l in straight_lasers:
		l.active = false
	for l in curve_lasers:
		for b in l.bullets:
			b.active = false
			
func clear_all_bullets():
	for b in active_bullets:
		b.free = true
	for l in loose_lasers:
		l.free = true
	for l in straight_lasers:
		l.free = true
	for l in curve_lasers:
		for b in l.bullets:
			b.free = true

var piv_count = 0

func clear_screen_fade(pos, r1, piv_items=false):
	for b in active_bullets:
		if pos.distance_squared_to(b.position) < (r1 + b.size) * (r1 + b.size):
			b.free = true
			if piv_items:
				create_item(b.position, ITEM.PIV, false, -90.0, 32.0, true, 0.0)
					
	for b in loose_lasers:
		if pos.distance_squared_to(b.position) < (r1 + b.length) * (r1 + b.length):
			b.free = true
			if piv_items:
				for i in b.length / 128:
					create_item(b.position - i * 128 * b.direction, ITEM.PIV, false, -90.0, 32.0, true, 0.0)
	
	for b in straight_lasers:
		if pos.distance_squared_to(b.position) < r1 * r1:
			b.free = true
			if piv_items:
				for i in b.length / 128:
					create_item(b.position + i * 128 * b.direction, ITEM.PIV, false, -90.0, 32.0, true, 0.0)

	for b in curve_lasers:
		if pos.distance_squared_to(b.points[-1]) < (r1) * (r1):
			b.free = true
			if piv_items:
				for bullet in b.bullets:
					create_item(bullet.position, ITEM.PIV, false, -90.0, 32.0, true, 0.0)

func _process(_delta):
	clear_offscreen_bullets()
	
	clear_bullets()
	
	move_bullets()
	
	#draw_items()
	
	# kek for whatever reason it won't render unless I render for at least 1 frame in GDScript and it can't be in _ready
	if f1:
		BulletRenderer.multimesh.visible_instance_count = 10000
		BulletRendererUpper.multimesh.visible_instance_count = 10000
		BulletRendererAdd.multimesh.visible_instance_count = 10000
		BulletClear.multimesh.visible_instance_count = 10000
		ItemRenderer.multimesh.visible_instance_count = 4096
		ItemTextRenderer.multimesh.visible_instance_count = 4096
		#draw_bullets()
		f1 = false
	
	# remove once curve is translated
	if !fast_forward || (fast_forward_frame_skip_timer <= 0):
		#draw_bullets()
		fast_forward_frame_skip_timer = FAST_FORWARD_FRAME_SKIP_TIME
	else:
		fast_forward_frame_skip_timer -= 1

func s(t):
	return t * 10 if t < 0.25 else 2.5 - (t - 0.25) * 2

var f1 = true

func draw_items():
	ItemRenderer.multimesh.visible_instance_count = 4096
	var count = 0
	var array = PoolRealArray()
	array.resize(4096 * 12)
	
	for item in active_items:
		#var data = Color(item.type, 0.0, item.scale, item.angle)
		array.set(count * 12, 1.0)
		array.set(count * 12 + 1, 0.0)
		array.set(count * 12 + 3, item.position.x)
		array.set(count * 12 + 4, 0.0)
		array.set(count * 12 + 5, 1.0)
		array.set(count * 12 + 7, item.position.y if item.position.y > -item.size else 40.0)
		array.set(count * 12 + 8, item.type)
		array.set(count * 12 + 9, 0.0 if item.position.y > -32 else 0.5)
		array.set(count * 12 + 10, item.scale)
		array.set(count * 12 + 11, item.angle if item.position.y > -32 else 0.0)
		count += 1

	ItemRenderer.multimesh.set_as_bulk_array(array)
	ItemRenderer.multimesh.visible_instance_count = count
	
	ItemTextRenderer.multimesh.visible_instance_count = 4096
	count = 0
	array = PoolRealArray()
	array.resize(4096 * 12)
	
	for item in collected_items:
		#var data = Color(item.type, 0.0, item.scale, item.angle)
		array.set(count * 12, 1.0)
		array.set(count * 12 + 1, 0.0)
		array.set(count * 12 + 3, item.collect_position.x)
		array.set(count * 12 + 4, 0.0)
		array.set(count * 12 + 5, 1.0)
		array.set(count * 12 + 7, item.collect_position.y)
		array.set(count * 12 + 8, item.point)
		array.set(count * 12 + 9, item.collect_timer)
		array.set(count * 12 + 10, item.max_value_float)
		count += 1

	ItemTextRenderer.multimesh.set_as_bulk_array(array)
	ItemTextRenderer.multimesh.visible_instance_count = count

# Reference code 
func draw_bullets():
	BulletRenderer.multimesh.visible_instance_count = 10000
	BulletRendererUpper.multimesh.visible_instance_count = 10000
	BulletRendererAdd.multimesh.visible_instance_count = 10000
	BulletClear.multimesh.visible_instance_count = 10000
	var count_alpha = 0
	var count_alpha_upper = 0
	var count_add = 0
	var count_clear = 0
	var array_alpha = PoolRealArray()
	array_alpha.resize(10000*16)
	var array_alpha_upper = PoolRealArray()
	array_alpha_upper.resize(10000*16)
	var array_add = PoolRealArray()
	array_add.resize(10000*16)
	var array_clear = PoolRealArray()
	array_clear.resize(10000*12)

	for b in []:
		if b.visible:
			var uv = b.uv
			if b.animated:
				b.anim_frame += b.anim_step
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				uv.r += uv.b * floor(b.anim_frame)
			
			var angle = b.sprite_angle-PI*0.5
			if b.type in Constants.NO_ROTATE_BULLETS:
				angle = 0.0
			
			var interp = max(float(b.fade_frames-1) / b.fade_time, 0.0)
			var scale = s(1-interp)
			
			if b.blend == BLEND_MODE_MIX:
				match b.layer:
					0:
						array_alpha.set(count_alpha*16, 1.0)
						array_alpha.set(count_alpha*16+1, 0.0)
						array_alpha.set(count_alpha*16+3, b.position.x)
						array_alpha.set(count_alpha*16+4, 0.0)
						array_alpha.set(count_alpha*16+5, 1.0)
						array_alpha.set(count_alpha*16+7, b.position.y)
						array_alpha.set(count_alpha*16+8, angle)
						array_alpha.set(count_alpha*16+9, b.offset)
						array_alpha.set(count_alpha*16+10, b.scale * scale)
						array_alpha.set(count_alpha*16+11, 1.0-interp)
						array_alpha.set(count_alpha*16+12, uv.r)
						array_alpha.set(count_alpha*16+13, uv.g)
						array_alpha.set(count_alpha*16+14, uv.b)
						array_alpha.set(count_alpha*16+15, uv.a)
						count_alpha += 1
					1:
						array_alpha_upper.set(count_alpha_upper*16, 1.0)
						array_alpha_upper.set(count_alpha_upper*16+1, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+3, b.position.x)
						array_alpha_upper.set(count_alpha_upper*16+4, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+5, 1.0)
						array_alpha_upper.set(count_alpha_upper*16+7, b.position.y)
						array_alpha_upper.set(count_alpha_upper*16+8, angle)
						array_alpha_upper.set(count_alpha_upper*16+9, b.offset)
						array_alpha_upper.set(count_alpha_upper*16+10, b.scale * scale)
						array_alpha_upper.set(count_alpha_upper*16+11, 1.0-interp)
						array_alpha_upper.set(count_alpha_upper*16+12, uv.r)
						array_alpha_upper.set(count_alpha_upper*16+13, uv.g)
						array_alpha_upper.set(count_alpha_upper*16+14, uv.b)
						array_alpha_upper.set(count_alpha_upper*16+15, uv.a)
						count_alpha_upper += 1
			elif b.blend == BLEND_MODE_ADD:
				array_add.set(count_add*16, 1.0)
				array_add.set(count_add*16+1, 0.0)
				array_add.set(count_add*16+3, b.position.x)
				array_add.set(count_add*16+4, 0.0)
				array_add.set(count_add*16+5, 1.0)
				array_add.set(count_add*16+7, b.position.y)
				array_add.set(count_add*16+8, angle)
				array_add.set(count_add*16+9, b.offset)
				array_add.set(count_add*16+10, b.scale * scale)
				array_add.set(count_add*16+11, 1.0-interp)
				array_add.set(count_add*16+12, uv.r)
				array_add.set(count_add*16+13, uv.g)
				array_add.set(count_add*16+14, uv.b)
				array_add.set(count_add*16+15, uv.a)
				count_add += 1
		
	for b in []:
		if b.visible:
			var uv = b.uv
			if b.animated:
				b.anim_frame += b.anim_step
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				uv.r += uv.b * floor(b.anim_frame)
			var angle = b.sprite_angle-PI*0.5
			
			var interp = max(float(b.fade_frames-1) / b.fade_time, 0.0)
			var scale = 1.0 - interp
			
			var xform = Transform2D(Vector2(b.width, 0.0), Vector2(0.0, b.length * scale), Vector2(0.0, 0.0)).rotated(angle)
			xform.origin = b.position - Vector2(0.0, b.length*0.5 * scale).rotated(angle)
			if b.blend == BLEND_MODE_MIX:
				match b.layer:
					0:
						array_alpha.set(count_alpha*16, xform[0].x)
						array_alpha.set(count_alpha*16+1, xform[1].x)
						array_alpha.set(count_alpha*16+3, xform.origin.x)
						array_alpha.set(count_alpha*16+4, xform[0].y)
						array_alpha.set(count_alpha*16+5, xform[1].y)
						array_alpha.set(count_alpha*16+7, xform.origin.y)
						array_alpha.set(count_alpha*16+8, 0.0)
						array_alpha.set(count_alpha*16+9, 0.0)
						array_alpha.set(count_alpha*16+10, 1.0)
						array_alpha.set(count_alpha*16+11, 1.0)
						array_alpha.set(count_alpha*16+12, uv.r)
						array_alpha.set(count_alpha*16+13, uv.g)
						array_alpha.set(count_alpha*16+14, uv.b)
						array_alpha.set(count_alpha*16+15, uv.a)
						count_alpha += 1
					1:
						array_alpha_upper.set(count_alpha_upper*16, xform[0].x)
						array_alpha_upper.set(count_alpha_upper*16+1, xform[1].x)
						array_alpha_upper.set(count_alpha_upper*16+3, xform.origin.x)
						array_alpha_upper.set(count_alpha_upper*16+4, xform[0].y)
						array_alpha_upper.set(count_alpha_upper*16+5, xform[1].y)
						array_alpha_upper.set(count_alpha_upper*16+7, xform.origin.y)
						array_alpha_upper.set(count_alpha_upper*16+8, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+9, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+10, 1.0)
						array_alpha_upper.set(count_alpha_upper*16+11, 1.0)
						array_alpha_upper.set(count_alpha_upper*16+12, uv.r)
						array_alpha_upper.set(count_alpha_upper*16+13, uv.g)
						array_alpha_upper.set(count_alpha_upper*16+14, uv.b)
						array_alpha_upper.set(count_alpha_upper*16+15, uv.a)
						count_alpha_upper += 1
			elif b.blend == BLEND_MODE_ADD:
				array_add.set(count_add*16, xform[0].x)
				array_add.set(count_add*16+1, xform[1].x)
				array_add.set(count_add*16+3, xform.origin.x)
				array_add.set(count_add*16+4, xform[0].y)
				array_add.set(count_add*16+5, xform[1].y)
				array_add.set(count_add*16+7, xform.origin.y)
				array_add.set(count_add*16+8, 0.0)
				array_add.set(count_add*16+9, 0.0)
				array_add.set(count_add*16+10, 1.0)
				array_add.set(count_add*16+11, 1.0)
				array_add.set(count_add*16+12, uv.r)
				array_add.set(count_add*16+13, uv.g)
				array_add.set(count_add*16+14, uv.b)
				array_add.set(count_add*16+15, uv.a)
				count_add += 1
	
			if interp > 0.0:
				uv = b.laser_spawn_uv
				array_add.set(count_add*16, 1.0)
				array_add.set(count_add*16+1, 0.0)
				array_add.set(count_add*16+3, b.position.x - b.length * b.direction.x * scale)
				array_add.set(count_add*16+4, 0.0)
				array_add.set(count_add*16+5, 1.0)
				array_add.set(count_add*16+7, b.position.y - b.length * b.direction.y * scale)
				array_add.set(count_add*16+8, randf()*360.0)
				array_add.set(count_add*16+9, b.offset)
				array_add.set(count_add*16+10, b.scale*2.0)
				array_add.set(count_add*16+11, 1.0)
				array_add.set(count_add*16+12, uv.r)
				array_add.set(count_add*16+13, uv.g)
				array_add.set(count_add*16+14, uv.b)
				array_add.set(count_add*16+15, uv.a)
				count_add += 1
			
	for b in []:
		if b.visible:
			var uv = b.uv
			if b.animated:
				b.anim_frame += b.anim_step
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				uv.r += uv.b * floor(b.anim_frame)
			
			var angle = b.angle-PI*0.5
			
			var interp = clamp(float(b.fade_frames) / b.fade_time, 0.0, 1.0)
			var scale = (1-interp)*0.75+0.25
			#var colour = Color(0,0,0,1)
			var alpha = 1.0
			if b.laser_complete:
				scale = interp
				alpha = interp
			
			var xform = Transform2D(Vector2(b.width * scale, 0.0), Vector2(0.0, b.length), Vector2(0.0, 0.0)).rotated(angle)
			#var xform = Transform2D(0.0, b.position)
			xform.origin = b.position + Vector2(0.0, b.length*0.5).rotated(angle)
			if b.blend == BLEND_MODE_MIX:
				match b.layer:
					0:
						array_alpha.set(count_alpha*16, xform[0].x)
						array_alpha.set(count_alpha*16+1, xform[1].x)
						array_alpha.set(count_alpha*16+3, xform.origin.x)
						array_alpha.set(count_alpha*16+4, xform[0].y)
						array_alpha.set(count_alpha*16+5, xform[1].y)
						array_alpha.set(count_alpha*16+7, xform.origin.y)
						array_alpha.set(count_alpha*16+8, 0.0)
						array_alpha.set(count_alpha*16+9, 0.0)
						array_alpha.set(count_alpha*16+10, 1.0)
						array_alpha.set(count_alpha*16+11, alpha)
						array_alpha.set(count_alpha*16+12, uv.r)
						array_alpha.set(count_alpha*16+13, uv.g)
						array_alpha.set(count_alpha*16+14, uv.b)
						array_alpha.set(count_alpha*16+15, uv.a)
						count_alpha += 1
					1:
						array_alpha_upper.set(count_alpha_upper*16, xform[0].x)
						array_alpha_upper.set(count_alpha_upper*16+1, xform[1].x)
						array_alpha_upper.set(count_alpha_upper*16+3, xform.origin.x)
						array_alpha_upper.set(count_alpha_upper*16+4, xform[0].y)
						array_alpha_upper.set(count_alpha_upper*16+5, xform[1].y)
						array_alpha_upper.set(count_alpha_upper*16+7, xform.origin.y)
						array_alpha_upper.set(count_alpha_upper*16+8, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+9, 0.0)
						array_alpha_upper.set(count_alpha_upper*16+10, 1.0)
						array_alpha_upper.set(count_alpha_upper*16+11, alpha)
						array_alpha_upper.set(count_alpha_upper*16+12, uv.r)
						array_alpha_upper.set(count_alpha_upper*16+13, uv.g)
						array_alpha_upper.set(count_alpha_upper*16+14, uv.b)
						array_alpha_upper.set(count_alpha_upper*16+15, uv.a)
						count_alpha_upper += 1
			elif b.blend == BLEND_MODE_ADD:
				array_add.set(count_add*16, xform[0].x)
				array_add.set(count_add*16+1, xform[1].x)
				array_add.set(count_add*16+3, xform.origin.x)
				array_add.set(count_add*16+4, xform[0].y)
				array_add.set(count_add*16+5, xform[1].y)
				array_add.set(count_add*16+7, xform.origin.y)
				array_add.set(count_add*16+8, 0.0)
				array_add.set(count_add*16+9, 0.0)
				array_add.set(count_add*16+10, 1.0)
				array_add.set(count_add*16+11, alpha)
				array_add.set(count_add*16+12, uv.r)
				array_add.set(count_add*16+13, uv.g)
				array_add.set(count_add*16+14, uv.b)
				array_add.set(count_add*16+15, uv.a)
				count_add += 1
				
			# LASER_SPAWN_UV
			uv = b.laser_spawn_uv
			array_add.set(count_add*16, 1.0)
			array_add.set(count_add*16+1, 0.0)
			array_add.set(count_add*16+3, b.position.x)
			array_add.set(count_add*16+4, 0.0)
			array_add.set(count_add*16+5, 1.0)
			array_add.set(count_add*16+7, b.position.y)
			array_add.set(count_add*16+8, randf()*360.0)
			array_add.set(count_add*16+9, b.offset)
			array_add.set(count_add*16+10, b.scale*(scale * 0.5 + 1.5))
			array_add.set(count_add*16+11, alpha)
			array_add.set(count_add*16+12, uv.r)
			array_add.set(count_add*16+13, uv.g)
			array_add.set(count_add*16+14, uv.b)
			array_add.set(count_add*16+15, uv.a)
			count_add += 1
						
	for laser in []:
		if laser.visible:
			if laser.animated:
				laser.anim_frame += laser.anim_step
				if laser.anim_frame >= laser.anim_frame_max:
					laser.anim_frame = 0
			
			#print(laser.get_mesh())
			var surface_count = laser.mesh.get_surface_count()
			for i in surface_count:
				laser.mesh.surface_remove(surface_count-1 - i)
			
			var st = SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
			
			if laser.animated:
				for i in len(laser.verts):
					st.add_uv(laser.uvs[i] + Vector2(laser.uv.b * floor(laser.anim_frame), 0))
					st.add_vertex(laser.verts[i])
			else:
				for i in len(laser.verts):
					st.add_uv(laser.uvs[i])
					st.add_vertex(laser.verts[i])
			st.commit(laser.mesh, 97280 + 262144)
			
	for b in []:
		var p = b.fade_position/b.fade_scale
		var xform = Transform2D(b.fade_angle, Vector2(p.x * b.fade_lr, p.y)).scaled(Vector2(b.fade_lr,1)*b.fade_scale)

		array_clear.set(count_clear*12, xform[0].x)
		array_clear.set(count_clear*12+1, xform[1].x)
		array_clear.set(count_clear*12+3, xform.origin.x)
		array_clear.set(count_clear*12+4, xform[0].y)
		array_clear.set(count_clear*12+5, xform[1].y)
		array_clear.set(count_clear*12+7, xform.origin.y)
		array_clear.set(count_clear*12+8, b.fade_colour.r)
		array_clear.set(count_clear*12+9, b.fade_colour.g)
		array_clear.set(count_clear*12+10, b.fade_colour.b)
		array_clear.set(count_clear*12+11, b.CLEAR_TIME - floor(b.clear_timer))# 
		
		count_clear += 1
		p = b.fade_position/(b.fade_scale * 2)
		xform = Transform2D(b.fade_angle2, Vector2(-p.x * b.fade_lr, p.y)).scaled(Vector2(-b.fade_lr,1)*b.fade_scale*2)

		array_clear.set(count_clear*12, xform[0].x)
		array_clear.set(count_clear*12+1, xform[1].x)
		array_clear.set(count_clear*12+3, xform.origin.x)
		array_clear.set(count_clear*12+4, xform[0].y)
		array_clear.set(count_clear*12+5, xform[1].y)
		array_clear.set(count_clear*12+7, xform.origin.y)
		array_clear.set(count_clear*12+8, b.fade_colour.r)
		array_clear.set(count_clear*12+9, b.fade_colour.g)
		array_clear.set(count_clear*12+10, b.fade_colour.b)
		array_clear.set(count_clear*12+11, b.CLEAR_TIME - floor(b.clear_timer))# 
		
		count_clear += 1
	
	BulletRenderer.multimesh.set_as_bulk_array(array_alpha)
	BulletRendererUpper.multimesh.set_as_bulk_array(array_alpha_upper)
	BulletRendererAdd.multimesh.set_as_bulk_array(array_add)
	BulletClear.multimesh.set_as_bulk_array(array_clear)
	BulletRenderer.multimesh.visible_instance_count = count_alpha
	BulletRendererUpper.multimesh.visible_instance_count = count_alpha_upper
	BulletRendererAdd.multimesh.visible_instance_count = count_add
	BulletClear.multimesh.visible_instance_count = count_clear
	

