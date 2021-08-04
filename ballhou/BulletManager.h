#pragma once
#include "Common.h"
#include <Node.hpp>
#include <Node2D.hpp>
#include "Bullet.h"
#include "Item.h"
#include <Rect2.hpp>
#include <vector>

class BulletManager : public Node
{
	GODOT_CLASS(BulletManager, Node);

	NodePath BulletsPath = NodePath();
	Node* Bullets = nullptr;

	NodePath PlayerPath = NodePath();
	Node2D* Player = nullptr;

	const vector<Vector2> FIREBALL_OFFSETS{ Vector2(1, 3), Vector2(0, 0), Vector2(1, 0), Vector2(0, 1), Vector2(0, 2), Vector2(1, 2), Vector2(0, 3), Vector2(1, 1) };

	const Vector2 UV_PIXEL = Vector2(1.0 / 512.0, 1.0 / 1024.0);
	
	const vector<float> BULLET_SIZES = {
		3, 1.5, 3, 3, 2.5, 2.5, 3, 2.8, 2.5, 2.5, 3, 2,
		2, 1.5, 3, 2,
		6, 8, 4, 3, 5, 6,
		14,
		10, 4, 2, 8, 4,
		14,
		5,
		5,
		30,
		30,
		10,
		10,
		3,
		3,
	};

	const vector<Vector3> LASER_SIZES = {
		Vector3(0.15, 0.05, 0.05), Vector3(0.1875, 0.6, 0.2), Vector3(0.15, 0.25, 0.25), Vector3(0.15, 0.25, 0.25), Vector3(0.25, 0.125, 0.125), Vector3(0.25, 0.125, 0.5), Vector3(0.25, 0.125, 0.125), Vector3(0.5, 0.125, 0.125), Vector3(0.25, 0.2, 0.125), Vector3(0.1, 0.3, 0.3), Vector3(0.25, 0.125, 0.125), Vector3(0.125, 0.25, 0.25),
			Vector3(0.25, 0.2, 0.2), Vector3(0.25, 0.2, 0.2), Vector3(0.375, 0.3125, 0.3125), Vector3(0.25, 0.2, 0.2),
			Vector3(0.3, 0.4, 0.3125), Vector3(0.5, 0.3125, 0.3125), Vector3(0.16, 0.43, 0.3125), Vector3(0.1, 0.1, 0.4), Vector3(0.1875, 0.28, 0.28), Vector3(0.3125, 0.35, 0.35),
			Vector3(0.45, 0.28, 0.28),
			Vector3(0.25, 0.35, 0.3), Vector3(0.15, 0.1, 0.72), Vector3(0.1875, 0.43, 0.43), Vector3(0.125, 0.25, 0.25), Vector3(0.375, 0.28, 0.375),
			Vector3(0.3, 0.35, 0.35),
			Vector3(0.15, 0.1, 0.1),
			Vector3(0.0625, 0.1, 0.1),
			Vector3(0.0625, 0.1, 0.1),
			Vector3(0.0625, 0.1, 0.1),
			Vector3(0.0625, 0.1, 0.1),
			Vector3(0.0625, 0.1, 0.1),
			Vector3(0.03, 0.1, 0.1),
			Vector3(0.15, 0.05, 0.05),
	};

	int small2largecolour(int x);
	int divine2largecolour(int x);
	int note2largecolour(int x);
	int coin2largecolour(int x);

	int get_large_colour(Bullet* b);

	void set_autodelete(Bullet* b, bool enable);
	void free_bullet(Bullet* b);
	void set_gravity(Bullet* b, Variant gravity, Variant max_speed);
	void set_layer(Bullet* b, int layer);
	void set_xy(Bullet* b, Variant x, Variant y);
	void aim_at_player(Bullet* b);
	void offset_angle(Bullet* b, float w);


	void transform_bullet(Bullet* b, Array t);

public:
	static void _register_methods();
	void _init();

	void _ready();
	void _process(float delta);

	Array get_uvs(int type, int colour);
	void update_bullet(Variant b, Variant position, Variant speed, Variant angle, Variant accel, Variant max_speed, Variant type_want, Variant colour_want, Variant fade, Variant w_vel, Variant spin, Variant blend, Variant laser, Variant laser_length = 10.0, Variant laser_width = 2.0);
	void move_bullets();
	Array player_collision(Vector2 pos, float r1, float r2, bool focused, float piv);

};

