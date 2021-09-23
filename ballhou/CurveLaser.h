#pragma once
#include "Common.h"
//#include <Object.hpp>
//#include <vector>
#include "Bullet.h"
#include <ArrayMesh.hpp>

//class ArrayMesh;
class CurveLaser : public Reference
{
	GODOT_CLASS(CurveLaser, Reference);


public:
	static void _register_methods();
	void _init();

	Ref<ArrayMesh> mesh = Ref<ArrayMesh>();
	Ref<ArrayMesh> get_mesh() const;
	void set_mesh(const Ref<ArrayMesh> &m);

	bool grazed = false;
	bool already_grazed = false;

	float length = 0.0f;
	int start_index = 0;
	PoolVector2Array points = PoolVector2Array();
	PoolVector3Array verts = PoolVector3Array();
	PoolVector2Array uvs = PoolVector2Array();
	int sample_rate = 2;
	Array bullets;
	float size = 0.0f;
	float width = 0.0f;
	float clearance_back = 0.0f;
	float clearance_front = 0.0f;
	bool free = true;

	Vector2 direction = Vector2(0, 0);
	float speed = 0.0f;
	float angle = 0.0f;
	float accel = 0.0f;
	float max_speed = 0.0f;
	float w_vel = 0.0f;
	Vector2 acc_vector = Vector2(0, 0);
	Vector2 vel_max_vector = Vector2(0, 0);

	Rect2 srect = Rect2();
	Rect2 texture_rect = Rect2();

	int type = 0;
	int colour = 0;

	bool visible = true;
	Color uv = Color();
	float scale = 1.0f;
	int blend = 0;
	Color laser_spawn_uv = Color();

	bool active = false;

	int anim_frame_max = 4;
	bool animated = false;
	float anim_step = 0.3334f;
	float anim_width = 32.0f;
	float anim_frame = 0.0f;

	int BULLET_FADE_TIME = 8;
	int fade_time = 8;
	int fade_frames = 0;

	int spawn_time = 0;

	Array transform_queue = Array();

};

