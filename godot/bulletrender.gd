extends Node2D

onready var root = get_parent()
onready var Bullets = Globals.Bullets

func _process(_delta):
	draw_bullets()
	#update()

func s(t):
	return t * 10 if t < 0.25 else 2.5 - (t - 0.25) * 2


func draw_bullets():
	draw_normal_bullets()
	draw_loose_lasers()
	draw_straight_lasers()
	draw_curve_lasers()

			
func draw_normal_bullets():
	for b in Bullets.active_bullets:
		if b.visible:
			var ci_rid = b.ci_rid
			if b.animated:
				b.anim_frame += 0.3334
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				
				var anim_floor = int(b.anim_frame)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor], true)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor-1], false)
				
				ci_rid = b.anim_ci_rids[anim_floor]
			
			var angle = (PI*0.5 + b.sprite_angle) if !b.no_rotate else PI*0.5
				
			if b.fade_frames == 0:
				if !b.animated:
					VisualServer.canvas_item_set_self_modulate(b.ci_rid, Color(1,1,1,1))	
				else:
					for i in 4:
						VisualServer.canvas_item_set_self_modulate(b.anim_ci_rids[i], Color(1,1,1,1))	
			
			if b.fade_frames <= 1:
				VisualServer.canvas_item_set_transform(ci_rid, Transform2D(angle, b.position))
			elif b.fade_frames > 0:
				var interp = max(float(b.fade_frames-1) / b.fade_time, 0.0)
				VisualServer.canvas_item_set_self_modulate(ci_rid, Color(1,1,1,1-interp))
				var scale = s(1-interp)
				VisualServer.canvas_item_set_transform(ci_rid, Transform2D(angle, b.position / scale).scaled(Vector2(1,1) * scale))
				
func draw_loose_lasers():
	for b in Bullets.loose_lasers:
		if b.visible:
			var ci_rid = b.ci_rid
			if b.animated:
				b.anim_frame += 0.3334
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				
				var anim_floor = int(b.anim_frame)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor], true)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor-1], false)
				
				ci_rid = b.anim_ci_rids[anim_floor]
			
			var angle = (PI*0.5 + b.sprite_angle)
			
			if b.fade_frames == 0:
				if !b.animated:
					VisualServer.canvas_item_set_self_modulate(b.ci_rid, Color(1,1,1,1))	
				else:
					for i in 4:
						VisualServer.canvas_item_set_self_modulate(b.anim_ci_rids[i], Color(1,1,1,1))	
			
			if b.fade_frames <= 1:
				VisualServer.canvas_item_set_transform(ci_rid, Transform2D(angle, b.position))
			else:
				var interp = max(float(b.fade_frames-1) / b.fade_time, 0.0)
				var interp_alpha = clamp(float(b.fade_frames - b.fade_time) / b.BULLET_FADE_TIME + 1.0, 0.0, 1.0)
				VisualServer.canvas_item_set_self_modulate(ci_rid, Color(1,1,1,(1-interp_alpha)))
				var scale = 1-interp
				var xform = Transform2D(Vector2(1.0,0.0), Vector2(0.0, scale), Vector2(0.0,0.0)).rotated(angle)
				xform.origin = b.position
				VisualServer.canvas_item_set_transform(ci_rid, xform)
			
func draw_straight_lasers():
	for b in Bullets.straight_lasers:
		if b.visible:
			var ci_rid = b.ci_rid
			if b.animated:
				b.anim_frame += 0.3334
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				
				var anim_floor = int(b.anim_frame)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor], true)
				VisualServer.canvas_item_set_visible(b.anim_ci_rids[anim_floor-1], false)
				
				ci_rid = b.anim_ci_rids[anim_floor]
			
			var angle = (PI*0.5 + b.angle)
			
			if !b.laser_complete && b.fade_frames == 0:
				if !b.animated:
					VisualServer.canvas_item_set_self_modulate(b.ci_rid, Color(1,1,1,1))	
				else:
					for i in 4:
						VisualServer.canvas_item_set_self_modulate(b.anim_ci_rids[i], Color(1,1,1,1))	
			
			if !b.laser_complete && b.fade_frames <= 1:
				VisualServer.canvas_item_set_transform(ci_rid, Transform2D(angle, b.position))
			else:
				var interp = clamp(float(b.fade_frames) / b.fade_time, 0.0, 1.0)
				var scale = (1-interp)*0.75+0.25
				if b.laser_complete: 
					scale = interp
					VisualServer.canvas_item_set_self_modulate(ci_rid, Color(1,1,1,interp))
				var xform = Transform2D(Vector2(scale,0.0), Vector2(0.0, 1.0), Vector2(0.0,0.0)).rotated(angle)
				xform.origin = b.position
				VisualServer.canvas_item_set_transform(ci_rid, xform)

func draw_curve_lasers():
	for l in Bullets.curve_lasers:
		var anim_floor = 0.0
		if l.animated:
			l.anim_frame += 0.3334
			if l.anim_frame >= l.anim_frame_max:
				l.anim_frame = 0
			
			anim_floor = floor(l.anim_frame)
		
		
		if l.points[-1] != l.points[-2]:
			VisualServer.canvas_item_set_visible(l.ci_rid, false)
		else:
			VisualServer.canvas_item_set_transform(l.ci_rid, Transform2D(randf()*360.0, l.points[-1]))
		
		for i in range(0, len(l.bullets)): 
			var op1 = false
			var op2 = false
			var b = l.points[i]
			var b_1 = l.points[i+1]
			if b == b_1:
				continue
			var v1 = b_1 - b
			var u1: Vector2
			if (i > 0) && (l.points[i-1] != b):
				u1 = l.points[i-1] - b
			else:
				u1 = -v1
			var u2 = -v1
			var v2: Vector2
			if (i < len(l.bullets) - 1) && (l.points[i+2] != b_1):
				v2 = l.points[i+2] - b_1
			else:
				v2 = -u2
			
			if u1.angle_to(v1) != 0:
				op1 = true
			if u2.angle_to(v2) != 0:
				op2 = true
			
				
			var s1: Vector2
			var s2: Vector2
			
			if !op1:
				s1 = (u1.length() * v1 + v1.length() * u1).normalized() * l.width * 0.5
			else:
				s1 = Vector2(-v1.y, v1.x).normalized() * l.width * 0.5
			if !op2:
				s2 = (u2.length() * v2 + v2.length() * u2).normalized() * l.width * 0.5
			else:
				s2 = Vector2(-v2.y, v2.x).normalized() * l.width * 0.5
				
			
			var points = PoolVector2Array()
			points.append(b + s1) # top left
			points.append(b_1 + s2) # top right
			points.append(b_1 - s2) # bottom right
			points.append(b - s1) # bottom left
			
			

			var bullet = l.bullets[i]
			
			var colours = PoolColorArray()
			for _i in range(4):
				colours.append(Color(1,1,1,1))
			var uvs = PoolVector2Array()
			var p = bullet.texture_rect.position
			var s = bullet.texture_rect.size
			if l.animated:
				p.x += anim_floor * l.anim_width
			uvs.append(Vector2((p.x + s.x) * 0.001953125, p.y * 0.0009765625))
			uvs.append(Vector2((p.x + s.x) * 0.001953125, (p.y + s.y) * 0.0009765625))
			uvs.append(Vector2((p.x) * 0.001953125, (p.y + s.y) * 0.0009765625))
			uvs.append(Vector2((p.x) * 0.001953125, p.y * 0.0009765625))
			
			VisualServer.canvas_item_clear(bullet.ci_rid)
			VisualServer.canvas_item_add_primitive(bullet.ci_rid, points, colours, uvs, bullet.texture)

