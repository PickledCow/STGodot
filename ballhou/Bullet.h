#pragma once
#include "Common.h"
#include <Object.hpp>
//#include <vector>

class Bullet : public Object
{
	GODOT_CLASS(Bullet, Object);




public:
	static void _register_methods();
	void _init();
	void hit();
	void move_bullet();
	Vector2 position = Vector2(0, 0);
	Vector2 direction = Vector2(0, 0);
	float speed = 0.0;
	float angle = 0.0;
	float accel = 0.0;
	float max_speed = 0.0;
	float w_vel = 0.0;
	Vector2 acc_vector = Vector2(0, 0);
	Vector2 vel_max_vector = Vector2(0, 0);

	bool grazed = false;
	bool already_grazed = false;
	int graze_frame = 0;
	int GRAZE_TIME = 8;

	bool no_rotate = false;
	float sprite_angle = 0.0;
	float spin = 0.0;

	int type = 0;
	int colour = 0;

	Color uv = Color();
	float scale = 1.0;
	int blend = 0;
	float offset = 0.0;

	Color laser_spawn_uv = Color();

	bool visible = true;
	int layer = 0;

	int anim_frame_max = 4;
	bool animated = false;
	float anim_step = 0.3334;
	float anim_width = 32.0;
	float anim_frame = 0.0;

	int collision_type = 0;
	float size = 0.0;
	float length = 0.0;
	float width = 0.0;
	float clearance_back = 0.0;
	float clearance_front = 0.0;
	bool free = true;
	bool auto_delete = true;

	int bounce_count = 0;
	bool bounced = false;
	bool bounce_bottom = false;
	bool bounce_top = true;
	bool bounce_left = true;
	bool bounce_right = true;

	int warp_count = 0;
	bool warped = false;
	bool warp_bottom = false;
	bool warp_top = false;
	bool warp_left = true;
	bool warp_right = true;

	bool active = false;

	Array transform_queue = Array();
	Array variables = Array();

	int BULLET_FADE_TIME = 8;
	int fade_time = 8;
	int fade_frames = 0;

	int laser_timer = 0;
	bool laser_complete = false;

	bool fade_clear = true;
	Vector2 fade_position = Vector2();
	Color fade_colour = Color();
	float CLEAR_TIME = 8;
	float clear_timer = 0;
	float fade_angle = 0.0;
	float fade_scale = 1.0;
	float fade_angle2 = 0.0;
	int fade_lr = 1;

};

