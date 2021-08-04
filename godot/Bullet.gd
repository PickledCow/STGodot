extends Object

var position = Vector2(0, 0)
var direction = Vector2(0,0)
var speed = 0.0
var angle = 0.0
var accel = 0.0
var max_speed = 0.0
var w_vel = 0.0
var acc_vector = Vector2(0,0)
var vel_max_vector = Vector2(0,0)

var grazed = false

var no_rotate = false
var sprite_angle = 0.0
var spin = 0.0

var type = 0
var colour = 0

var uv = Color()
var scale = 1.0
var blend = 0
var offset = 0.0

var laser_spawn_uv = Color()

var visible = true
var layer = 0

const anim_frame_max = 4
var animated = false
var anim_step = 0.3334
var anim_width = 32
var anim_frame = 0

var collision_type = 0
var size = 0.0
var length = 0.0
var width = 0.0
var clearance_back = 0.0
var clearance_front = 0.0
var free = true
var auto_delete = true

var bounce_count = 0
var bounce_bottom = false
var bounce_top = true
var bounce_left = true
var bounce_right = true

var warp_count = 0
var warp_bottom = false
var warp_top = false
var warp_left = true
var warp_right = true

var active = false

var transform_queue = []
var variables = []

const BULLET_FADE_TIME = 8
var fade_time = 8
var fade_frames = 0

var laser_timer = 0
var laser_complete = false

var fade_clear = true
var fade_position: Vector2
var fade_colour: Color
const CLEAR_TIME = 8
var clear_timer = 0
var fade_angle = 0.0
var fade_scale = 1.0
var fade_angle2 = 0.0
var fade_lr = 1

func hit():
	if collision_type != Constants.BULLET_KIND.CURVE_LASER:
		free = true

