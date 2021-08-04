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
	float spin = 1.0;
	float angle = 0.0;
	Vector2 direction = Vector2();
	float DAMP = 0.9;
	float up_speed = 24.0;
	float speed = 2.0;
	float type = 0.0;
	float size = 64.0;
	float poc_size = 128.0;
	float scale = 64.0;
	const float OFFSCREEN_SCALE = 64.0;
	int spawn_timer = 45;
	bool poced = false;
	bool max_value = false;
	bool free = false;
			
	Vector2 collect_position = Vector2();
	float collect_timer = 1.0;
	float point = 0.0;
	float max_value_float = 0.0;
};

