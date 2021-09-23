#include "Bullet.h"

void Bullet::_register_methods()
{
	register_method("hit", &Bullet::hit);
	register_method("move_bullet", &Bullet::move_bullet);


	register_property("position", &Bullet::position, Vector2(0, 0));
	register_property("direction", &Bullet::direction, Vector2(0, 0));
	register_property("speed", &Bullet::speed, 0.0f);
	register_property("angle", &Bullet::angle, 0.0f);
	register_property("accel", &Bullet::accel, 0.0f);
	register_property("max_speed", &Bullet::max_speed, 0.0f);
	register_property("w_vel", &Bullet::w_vel, 0.0f);
	register_property("acc_vector", &Bullet::acc_vector, Vector2(0, 0));
	register_property("vel_max_vector", &Bullet::vel_max_vector, Vector2(0, 0));

	register_property("grazed", &Bullet::grazed, false);
	register_property("already_grazed", &Bullet::already_grazed, false);
	register_property("graze_frame", &Bullet::graze_frame, 0);
	register_property("GRAZE_TIME", &Bullet::GRAZE_TIME, 8);

	register_property("no_rotate", &Bullet::no_rotate, false);
	register_property("sprite_angle", &Bullet::sprite_angle, 0.0f);
	register_property("spin", &Bullet::spin, 0.0f);

	register_property("type", &Bullet::type, 0);
	register_property("colour", &Bullet::colour, 0);

	register_property("uv", &Bullet::uv, Color());
	register_property("scale", &Bullet::scale, 1.0f);
	register_property("blend", &Bullet::blend, 0);
	register_property("offset", &Bullet::offset, 1.0f);

	register_property("laser_spawn_uv", &Bullet::laser_spawn_uv, Color());

	register_property("visible", &Bullet::visible, false);
	register_property("layer", &Bullet::layer, 0);

	register_property("anim_frame_max", &Bullet::anim_frame_max, 4);
	register_property("animated", &Bullet::animated, false);
	register_property("anim_step", &Bullet::anim_step, 0.3334f);
	register_property("anim_width", &Bullet::anim_width, 32.0f);
	register_property("anim_frame", &Bullet::anim_frame, 0.0f);

	register_property("collision_type", &Bullet::collision_type, 0);
	register_property("size", &Bullet::size, 0.0f);
	register_property("length", &Bullet::length, 0.0f);
	register_property("width", &Bullet::width, 0.0f);
	register_property("clearance_back", &Bullet::clearance_back, 0.0f);
	register_property("clearance_front", &Bullet::clearance_front, 0.0f);
	register_property("free", &Bullet::free, true);
	register_property("auto_delete", &Bullet::auto_delete, true);

	register_property("bounce_count", &Bullet::bounce_count, 0);
	register_property("bounced", &Bullet::bounced, false);
	register_property("bounce_bottom", &Bullet::bounce_bottom, false);
	register_property("bounce_top", &Bullet::bounce_top, true);
	register_property("bounce_left", &Bullet::bounce_left, true);
	register_property("bounce_right", &Bullet::bounce_right, true);

	register_property("warp_count", &Bullet::warp_count, 0);
	register_property("warped", &Bullet::warped, false);
	register_property("warp_bottom", &Bullet::warp_bottom, false);
	register_property("warp_top", &Bullet::warp_top, false);
	register_property("warp_left", &Bullet::warp_left, true);
	register_property("warp_right", &Bullet::warp_right, true);

	register_property("active", &Bullet::active, false);

	register_property("transform_queue", &Bullet::transform_queue, Array());
	register_property("variables", &Bullet::variables, Array());

	register_property("BULLET_FADE_TIME", &Bullet::BULLET_FADE_TIME, 8);
	register_property("fade_time", &Bullet::fade_time, 8);
	register_property("fade_frames", &Bullet::fade_frames, 0);

	register_property("laser_timer", &Bullet::laser_timer, 0);
	register_property("laser_complete", &Bullet::laser_complete, false);

	register_property("fade_clear", &Bullet::fade_clear, true);
	register_property("fade_position", &Bullet::fade_position, Vector2());
	register_property("fade_colour", &Bullet::fade_colour, Color());
	register_property("CLEAR_TIME", &Bullet::CLEAR_TIME, 8.0f);
	register_property("clear_timer", &Bullet::clear_timer, 0.0f);
	register_property("fade_angle", &Bullet::fade_angle, 0.0f);
	register_property("fade_scale", &Bullet::fade_scale, 1.0f);
	register_property("fade_angle2", &Bullet::fade_angle2, 0.0f);
	register_property("fade_lr", &Bullet::fade_lr, 1);
}

void Bullet::_init()
{
}

void Bullet::hit()
{
	free = true;
}

void Bullet::move_bullet() {
	if (!free) {
		if (fade_frames > 0) {
			fade_frames -= 1;
			if (fade_frames <= fade_time - 6) {
				active = true;
			}
		}
		if (w_vel != 0.0) {
			angle += w_vel;
			sprite_angle += w_vel;
			direction = Vector2(cos(angle), sin(angle));
		}
		if (accel && speed != max_speed) {
			speed += accel;
			if ((accel < 0 && speed < max_speed) || (accel > 0 && speed > max_speed)) {
				speed = max_speed;
			}
		}
		if (acc_vector.length_squared()) {
			Vector2 velocity = speed * direction;
			velocity += acc_vector;
			if ((acc_vector.x > 0 && velocity.x > vel_max_vector.x) || (acc_vector.x < 0 && velocity.x < vel_max_vector.x)) {
				velocity.x = vel_max_vector.x;
			}
			if ((acc_vector.y > 0 && velocity.y > vel_max_vector.y) || (acc_vector.y < 0 && velocity.y < vel_max_vector.y)) {
				velocity.y = vel_max_vector.y;
			}
			speed = velocity.length();
			direction = velocity / speed;
			float d_angle = velocity.angle() - angle;
			angle += d_angle;
			sprite_angle += d_angle;
			
		}
		position += direction * speed;
		sprite_angle += spin;

		bounced = false;
		// TODO: make the constants not magic
		if (bounce_count != 0) {
			if (bounce_left && position.x < 0.0f) {
				position.x *= -1;
				direction.x *= -1;
				angle = 3.14159265358979323846f - angle;
				sprite_angle = 3.14159265358979323846f - sprite_angle;
				bounce_count -= 1;
				bounced = true;
			}
			else if (bounce_right && position.x > 1000.0f) {
				position.x = 2000.0f - position.x;
				direction.x *= -1;
				angle = 3.14159265358979323846f - angle;
				sprite_angle = 3.14159265358979323846f - sprite_angle;
				bounce_count -= 1;
				bounced = true;
			}
		}
		if (bounce_count != 0) {
			if (bounce_top && position.y < 0.0f) {
				position.y *= -1;
				direction.y *= -1;
				angle *= -1;
				sprite_angle *= -1;
				bounce_count -= 1;
				bounced = true;
			}
			else if (bounce_bottom && position.y > 1000.0f) {
				position.y = 2000.0f - position.y;
				direction.y *= -1;
				angle *= -1;
				sprite_angle *= -1;
				bounce_count -= 1;
				bounced = true;
			}
		}
		warped = false;

		// TODO add variable warp maybe

		if (warp_count != 0) {
			if (warp_left && position.x < -80.0) {
				position.x += 1000.0 + 160.0;
				warp_count -= 1;
				warped = true;
			}
			else if (warp_right && position.x > 1000.0 + 80.0) {
				position.x -= 1000.0 + 160.0;
				warp_count -= 1;
				warped = true;
			}
		}
		if (warp_count != 0) {
			if (warp_top && position.y < -80.0) {
				position.y += 1000.0 + 160;
				warp_count -= 1;
				warped = true;
			}
			else if (warp_bottom && position.y > 1000.0 + 80.0) {
				position.y -= 1000.0 + 160.0;
				warp_count -= 1;
				warped = true;
			}
		}
	}
}