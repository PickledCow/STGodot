#pragma once
#include "Common.h"
#include <Object.hpp>
class PlayerBullet : public Object
{
	GODOT_CLASS(PlayerBullet, Object);



public:
	static void _register_methods();
	void _init();
	void hit();
	void move_bullet();
	Vector2 position;
	Vector2 direction = Vector2(1, 0);
	float speed = 1.0f;
	float angle = 0.0f;
	float accel = 0.0f;
	float max_speed = 1.0f;

	Color uv = Color();
	float scale = 1.0f;

	int damage = 1;

	float life_time = 10.0f;
	float life_timer = 0.0f;

	bool is_homing = false;
	float homing_radius = 0.0f;

	bool is_splash = false;
	float splash_radius = 0.0f;
	int splash_damage = 0;

	bool active = false;
};

