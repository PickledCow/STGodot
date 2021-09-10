#include "PlayerBullet.h"

void PlayerBullet::_register_methods()
{
}

void PlayerBullet::_init()
{
}

void PlayerBullet::hit()
{
}

void PlayerBullet::move_bullet()
{
	
	position += direction * speed;
	//Godot::print(String::num_real(position.x));
	speed = min(speed + accel, max_speed);

	life_timer += 1;
	if (life_timer >= life_time) {
		active = false;
	}
}
