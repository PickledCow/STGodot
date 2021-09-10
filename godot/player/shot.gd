extends Node2D

var speed = 20
var accel = 0
var max_speed = 20
var angle = 0
var direction = Vector2(1, 0)
var damage = 10

var piercing = false
var damaged_enemies = []
var limited_life = false
var life_timer = 0.0
var life_time = 1.0

var laser_animation = true

var radial_homing = false
var turn_rate = 0.1
var lateral_homing = false
var turned = false

var active = true

onready var splash = get_node("Particles2D")
onready var sprite = get_node("Sprite")
onready var collision_box = get_node("Area2D")
onready var radial_detector = get_node("RadialDetector")
onready var lateral_detector = get_node("LateralDetector")

func _ready():
	if lateral_homing:
		lateral_detector.monitoring = true
	if radial_homing:
		radial_detector.monitoring = true

func _process(delta):
	if laser_animation:
		sprite.region_rect.position.x = 256 * (life_timer / life_time)



	if active:
		if accel != 0:
			speed += accel
			if speed > max_speed:
				speed = max_speed
				accel = 0
		
		position += direction * speed
		
		var collisions = collision_box.get_overlapping_areas()
		
		if !piercing:
			if collisions:
				var enemy = collisions[0].get_parent()
				enemy.hit(damage)
				active = false
				sprite.visible = false
				#splash.emitting = true
		else:
			for enemy_hitbox in collisions:
				var enemy = enemy_hitbox.get_parent()
				if enemy in damaged_enemies:
					continue
				enemy.hit(damage)
				damaged_enemies.append(enemy)
				
			
		if !limited_life && !Constants.CLEAR_RECT.has_point(position):
			queue_free()
		elif limited_life:
			life_timer -= 1
			if life_timer <= 0:
				queue_free()
		
		if radial_homing:
			var detections = radial_detector.get_overlapping_areas()
			if detections:
				var enemy = detections[0].get_parent()
				var angle_diff = (direction).angle_to(enemy.position-position)
				
				if angle_diff > turn_rate:
					angle += turn_rate
					rotation = angle
					direction = Vector2(1, 0).rotated(angle)
				elif angle_diff < turn_rate:
					angle -= turn_rate
					rotation = angle
					direction = Vector2(1, 0).rotated(angle)
				else:
					direction = (enemy.position-position).normalized()
					angle = direction.angle()
		elif lateral_homing:
			if !turned:
				var detections = lateral_detector.get_overlapping_areas()
				if detections:
					var enemy = detections[0].get_parent()
					if enemy.position.x < position.x - 10:
						angle = PI
						rotation = PI
						direction = Vector2(-1, 0)
						turned = true
					elif enemy.position.x > position.x + 10:
						angle = 0
						rotation = 0
						direction = Vector2(1, 0)
						turned = true
	else:
		if !splash.emitting:
			queue_free()
