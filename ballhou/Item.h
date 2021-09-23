#pragma once
#include "Common.h"
#include <Object.hpp>
class Item : public Object
{
	GODOT_CLASS(Item, Object);

public:
	static void _register_methods();
	void _init();

	Vector2 position = Vector2();
	float spin = 1.0f;
	float angle = 0.0f;
	Vector2 direction = Vector2();
	float DAMP = 0.9f;
	float up_speed = 24.0f;
	float speed = 2.0f;
	int type = 0;
	float size = 64.0f;
	float poc_size = 128.0f;
	float scale = 64.0f;
	const float OFFSCREEN_SCALE = 64.0f;
	int spawn_timer = 45;
	bool poced = false;
	bool max_value = false;
	bool free = false;
			
	Vector2 collect_position = Vector2();
	float collect_timer = 1.0f;
	float point = 0.0f;
	float max_value_float = 0.0f;
};

