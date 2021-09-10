#pragma once
#include "Common.h"
#include <Object.hpp>
#include <Node.hpp>
#include "PlayerBullet.h"
#include <MultiMeshInstance2D.hpp>
#include <MultiMesh.hpp>
#include <vector>

class PlayerBulletManager : public Node
{
	GODOT_CLASS(PlayerBulletManager, Object);



public:
	NodePath BulletRendererPath = NodePath();
	Ref<MultiMesh> BulletRendererMesh;

	Array bullets;
	Array free_bullets;

	static void _register_methods();
	void _init();
	void _ready();
	void _process();
	void create_bullet(Vector2 position, float speed, float angle, float accel, float max_speed, int type, int damage, bool homing, float homing_radius, bool splash, float splash_radius, int splash_damage, int lifetime);
};

