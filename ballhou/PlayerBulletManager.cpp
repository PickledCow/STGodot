#include "PlayerBulletManager.h"
#include <string>

void PlayerBulletManager::_register_methods()
{
	register_method("_ready", &PlayerBulletManager::_ready);
	register_method("_process", &PlayerBulletManager::_process);


	register_property("BulletRendererPath", &PlayerBulletManager::BulletRendererPath, NodePath());
	register_property("bullets", &PlayerBulletManager::bullets, Array());
}

void PlayerBulletManager::_init()
{
}

void PlayerBulletManager::_ready()
{

	MultiMeshInstance2D* BulletRenderer = (MultiMeshInstance2D*)get_node(BulletRendererPath);
	BulletRendererMesh = BulletRenderer->get_multimesh();


}

void PlayerBulletManager::_process()
{
	for (int i = 0; i < bullets.size(); ++i) {
		PlayerBullet* b = (PlayerBullet*)bullets[i];
		b->move_bullet();
	}


	BulletRendererMesh->set_visible_instance_count(1000);
	PoolRealArray array_alpha = PoolRealArray();
	array_alpha.resize(1000 * 16);
	int count_alpha = 0;
	for (int i = 0; i < min(1000, (int)bullets.size()); ++i) {
		PlayerBullet* b = (PlayerBullet*)bullets[i];
		Vector2 b_position = b->position;
		//Godot::print(String::num_real(b_position.x));

		array_alpha.set(count_alpha * 16, 1.0);
		array_alpha.set(count_alpha * 16 + 1, 0.0);
		array_alpha.set(count_alpha * 16 + 3, b_position.x);
		array_alpha.set(count_alpha * 16 + 4, 0.0);
		array_alpha.set(count_alpha * 16 + 5, 1.0);
		array_alpha.set(count_alpha * 16 + 7, b_position.y);
		array_alpha.set(count_alpha * 16 + 8, 1.0);
		array_alpha.set(count_alpha * 16 + 9, 1.0);
		array_alpha.set(count_alpha * 16 + 10, 1.0);
		array_alpha.set(count_alpha * 16 + 11, 1.0);
		array_alpha.set(count_alpha * 16 + 12, 1.0);
		array_alpha.set(count_alpha * 16 + 13, 1.0);
		array_alpha.set(count_alpha * 16 + 14, 1.0);
		array_alpha.set(count_alpha * 16 + 15, 1.0);
		count_alpha += 1;
	}
	BulletRendererMesh->set_as_bulk_array(array_alpha);
	BulletRendererMesh->set_visible_instance_count(count_alpha);
}

void PlayerBulletManager::create_bullet(Vector2 position, float speed, float angle, float accel, float max_speed, int type, int damage, bool homing, float homing_radius, bool splash, float splash_radius, int splash_damage, int lifetime)
{
}
