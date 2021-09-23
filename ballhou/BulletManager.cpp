#include "BulletManager.h"

int BulletManager::small2largecolour(int x)
{
	if (x < 11) return int((x + 1) * 0.5);
	else if (x == 11) return 5;
	else if (x < 15) return int(x * 0.5);
	else return 0;
}


int BulletManager::divine2largecolour(int x)
{
	if (x < 7) return x;
	else if (x == 7) return 0;
	else if (x == 8) return 7;
	else if (x < 15) return x - 8;
	else return 0;
}

int BulletManager::note2largecolour(int x)
{
	if (x < 3) return x + 1;
	else if (x == 3) return 6;
	else return 0;
}

int BulletManager::coin2largecolour(int x)
{
	if (x < 6) return x + 1;
	else if (x == 6) return 0;
	else return 7;
}

int BulletManager::get_large_colour(Bullet* b)
{ // TODO: IMPLIMENT THISs
	int c = b->colour;
	
	if (b->type <= 13 || b->type == 15) c = small2largecolour(c);
	else if (b->type == 30) c = 3;
	else if (b->type == 28) c = divine2largecolour(c);
	else if (b->type == 36) c = note2largecolour(c);
	else if (b->type == 14) c = coin2largecolour(c);
	else if (b->type >= 31 && b->type <= 34) c = 0;
	else if (b->type == 35) c = 5;
		
	return c;
}

void BulletManager::set_autodelete(Bullet* b, bool enable)
{
	if (b) {
		b->auto_delete = enable;
	}
}

void BulletManager::free_bullet(Bullet* b)
{
	if (b) {
		b->free = true;
	}
}

void BulletManager::set_gravity(Bullet* b, Variant gravity, Variant max_speed)
{
	if (b) {
		if (gravity.get_type() == Variant::VECTOR2) {
			b->acc_vector = (Vector2)gravity;
		}
		if (max_speed.get_type() == Variant::VECTOR2) {
			b->vel_max_vector = (Vector2)max_speed;
		}
	}
}

void BulletManager::set_layer(Bullet* b, int layer)
{
	if (b) {
		b->layer = layer;
	}
}

void BulletManager::set_xy(Bullet* b, Variant x, Variant y)
{
	if (b) {
		if (x.get_type() == Variant::INT || x.get_type() == Variant::REAL) {
			b->position.x = x;
		}
		if (y.get_type() == Variant::INT || y.get_type() == Variant::REAL) {
			b->position.y = y;
		}
	}
}

void BulletManager::aim_at_player(Bullet* b)
{
	if (b) {
		float angle = Player->get_position().angle_to_point(b->position);
		update_bullet(b, "", "", 57.2957795131f * angle, "", "", "", "", "", "", "", "", "");
	}
}

void BulletManager::offset_angle(Bullet* b, float w)
{
	if (b) {
		update_bullet(b, "", "", 57.2957795131f * b->angle + w, "", "", "", "", "", "", "", "", "");
	}
}

void BulletManager::transform_bullet(Bullet* b, Array t)
{
	int t_cond = (int)t[1];
	if (t_cond == 0) {
		update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14]);
	}
	else if (t_cond == 1) {
		set_autodelete(b, t[2]);
	}
	else if (t_cond == 2) {
		free_bullet(b);
	}
	else if (t_cond == 3) {
		set_gravity(b, t[2], t[3]);
	}
	else if (t_cond == 6) {
		set_layer(b, t[2]);
	}
	else if (t_cond == 7) {
		set_xy(b, t[2], t[3]);
	}
	else if (t_cond == 8) {
		aim_at_player(b);
	}
	else if (t_cond == 9) {
		offset_angle(b, t[2]);
	}
	/*
	switch (t_cond) {
		case 0:
			update_bullet(b, t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14]);
		case 1:
			set_autodelete(b, t[2]);
		case 2:
			free_bullet(b);
		case 3:
			set_gravity(b, t[2], t[3]);
		case 6:
			set_layer(b, t[2]);
		case 7:
			set_xy(b, t[2], t[3]);
		case 8:
			aim_at_player(b);
		case 9:
			offset_angle(b, t[2]);
	}
	*/
}

void BulletManager::_register_methods()
{
	register_method("_ready", &BulletManager::_ready);
	register_method("_process", &BulletManager::_process);
	register_method("get_uvs", &BulletManager::get_uvs);
	register_method("update_bullet", &BulletManager::update_bullet);
	register_method("move_bullets", &BulletManager::move_bullets);
	register_method("aim_at_player", &BulletManager::aim_at_player);
	register_method("offset_angle", &BulletManager::offset_angle);
	register_method("player_collision", &BulletManager::player_collision);


	register_property("BulletsPath", &BulletManager::BulletsPath, NodePath());
	register_property("PlayerPath", &BulletManager::PlayerPath, NodePath());
}

void BulletManager::_init()
{
}

void BulletManager::_ready()
{
	Bullets = get_node(BulletsPath);
	Player = (Node2D*)get_node(PlayerPath);
}

void BulletManager::_process(float delta)
{
}

// TODO: demagic number this

Array BulletManager::get_uvs(int type, int colour)
{
	Rect2 srect;
	float offset = 0.0f;
	float scale = 1.0f;
	int tex = 1;
	bool animated = false;
	float anim_width = 64.0f;
	int b_col = colour;
	Color uv = Color();
	float anim_step = 0.3334f;

	// Sheet 1
	if (type <= 11) { // Regular bullets
		srect = Rect2(16.0f * colour, 16.0f * type, 16.0f, 16.0f);
		if (type == 1) { // Kunai and arrowheads on spritesheet aren't centered on the tip
			offset = -6.5f / 32.0f;
		}
		else if (type == 5) {
			offset = 5.0f / 32.0f;
		}
	} 
	else if (type <= 13) { // Popcorn and small rice
		srect = Rect2(8.0f * (colour % 8) + 64.0f * (type - 12), 192.0f + 8.0f * floor(colour * 0.125f), 8.0f, 8.0f);
		scale = 0.5;
	} 
	else if (type == 14) { // Coin
		srect = Rect2(128.0f + 16.0f * colour, 192.0f, 16.0f, 16.0f);
	} 
	else if (type == 15) { // Snowball
		srect = Rect2(8.0f * (colour % 8), 240.0f + 8.0f * floor(colour * 0.125f), 8.0f, 8.0f);
		scale = 0.5;
	} else if (type <= 21) { // Large Star to buffer
		tex = 2;
		scale = 2.0f;
		if (type == 19) {
			offset = 9.0f / 64.0f;
		}
		srect = Rect2(256.0f + 32.0f * colour, 32.0f * (type - 16), 32.0f, 32.0f);
	}
	// Sheet 3 (bubbles)
	else if (type == 22) {
		tex = 3;
		scale = 4.0f;
		srect = Rect2(64.0f * floor(colour / 2), 256.0f + 64.0f * (colour % 2), 64.0f, 64.0f);
	}
	// Sheet 4 (special)
	else if (type <= 26) {
		tex = 4;
		scale = 2.0f;
		if (type == 24){ // Arrows on spritesheet aren't centered on the tip
			offset = 18.0f / 64.0f;
		}
		srect = Rect2(256.0f + 32.0f * colour, 256.0f + 32.0f * (type - 23), 32.0f, 32.0f);
	}
	else if (type == 27) {
		tex = 4;
		scale = 2.0f;
		offset = 4.0f / 64.0f;
		Vector2 oset = FIREBALL_OFFSETS[colour];
		srect = Rect2(256 + 4 * 32 * oset.x, 256 + 128 + 32 * oset.y, 32, 32);
		animated = true;
	}
	else if (type == 28) {
		tex = 5;
		scale = 4.0f;
		srect = Rect2(64.0f * (colour % 4), 256.0f + 128.0f + 64.0f * floor(colour * 0.25f), 64.0f, 64.0f);
	}
// Lasers, don't use them as bullets please 
	else if (type == 29) {
		srect = Rect2(16.0f * colour, 640.0f, 16.0f, 256.0f);
	}
	else if (type == 30) {
		srect = Rect2(128, 640, 32, 256);
		animated = true;
		anim_width = 32;
	}
	else if (type == 31) {
		srect = Rect2(256, 192, 64, 64);
		b_col = 0;
		scale = 4.0f;
	}
	else if (type == 32) {
		srect = Rect2(320.0f + colour * 64.0f * (rand() % 2 + 1), 192.0f, 64.0f, 64.0f);
		scale = 4.0f;
	}
	else if (type == 33) {
		srect = Rect2(256, 160, 32, 32);
		b_col = 0;
		scale = 2.0f;
	}
	else if (type == 34) {
		srect = Rect2(288.0f + colour * 32.0f * (rand() % 2 + 1), 160.0f, 32.0f, 32.0f);
		scale = 2.0f;
	}
	else if (type == 35) {
		srect = Rect2(384.0f, 160.0f, 32.0f, 32.0f);
		scale = 2.0f;
	}
	else if (type == 36) {
		scale = 2.0f;
		offset = 20.0f / 64.0f;
		srect = Rect2(128.0f * (colour % 2), 896.0f + 32.0f * (colour / 2), 32.0f, 32.0f);
		animated = true;
		anim_step = 0.08334f;
	}

	scale *= 40.0f;
	/*
	switch (tex) {
	}*/
	uv = Color(srect.position.x * UV_PIXEL.x, srect.position.y * UV_PIXEL.y, srect.size.x * UV_PIXEL.x, srect.size.y * UV_PIXEL.y);

	// return[offset, scale, animated, anim_step, anim_width, b_col, uv]

	Array arr;
	arr.append(offset);
	arr.append(scale);
	arr.append(animated);
	arr.append(anim_step);
	arr.append(anim_width);
	arr.append(b_col);
	arr.append(uv);
	return arr;
}

void BulletManager::update_bullet(Variant b, Variant position, Variant speed, Variant angle, Variant accel, Variant max_speed, Variant type_want, Variant colour_want, Variant fade, Variant w_vel, Variant spin, Variant blend, Variant laser, Variant laser_length, Variant laser_width)
{

	Bullet* bullet = (Bullet*)b;

	// Update bullet data if they aren't null
	if (position.get_type() == Variant::VECTOR2) bullet->position = (Vector2)position;
	if (speed.get_type() == Variant::REAL || speed.get_type() == Variant::INT) bullet->speed = (float)speed;

	if (angle.get_type() == Variant::REAL || angle.get_type() == Variant::INT) {
		float true_angle = (float)angle * 0.01745329251f;
		bullet->angle = true_angle;
		bullet->sprite_angle = true_angle;
		bullet->direction = Vector2(cos(true_angle), sin(true_angle));
	}
	if (accel.get_type() == Variant::REAL || accel.get_type() == Variant::INT) bullet->accel = (float)accel;
	if (max_speed.get_type() == Variant::REAL || max_speed.get_type() == Variant::INT) bullet->max_speed = (float)max_speed;
	if (w_vel.get_type() == Variant::REAL || w_vel.get_type() == Variant::INT) bullet->w_vel = (float)w_vel * 0.01745329251f;
	if (spin.get_type() == Variant::REAL || spin.get_type() == Variant::INT) bullet->spin = (float)spin * 0.01745329251f;
	if (blend.get_type() == Variant::INT || blend.get_type() == Variant::REAL) bullet->blend = (int)blend;


	// If either the type, colour, or laser type is set to update, do so
	if (type_want.get_type() == Variant::INT || colour_want.get_type() == Variant::INT || laser.get_type() == Variant::INT) {
		int type = bullet->type;
		if (type_want.get_type() == Variant::INT || type_want.get_type() == Variant::REAL) {
			type = type_want;
			bullet->type = type;
		}
		int colour = bullet->colour;
		if (colour_want.get_type() == Variant::INT || colour_want.get_type() == Variant::REAL) {
			colour = colour_want;
			bullet->colour = colour;
		}
		bullet->no_rotate = false; // type in Constants.NO_ROTATE_BULLETS  TODO: FIX LATER MAYBE
		bullet->animated = false;
		bullet->collision_type = laser;

		//[offset, scale, animated, anim_step, anim_width, b_col, uv]
		Array values = get_uvs(type, colour);
		bullet->offset = values[0];
		bullet->scale = values[1];
		bullet->animated = values[2];
		bullet->anim_step = values[3];
		bullet->anim_width = values[4];
		bullet->colour = values[5];
		bullet->uv = values[6];

		Color laser_spawn_uv = Color(0.0f, 416.0f / 2048.0f, 64.0f / 1024.0f, 64.0f / 2048.0f);
		laser_spawn_uv.r += laser_spawn_uv.b * get_large_colour(bullet);
		bullet->laser_spawn_uv = laser_spawn_uv;
		if (laser.get_type() == Variant::INT || laser.get_type() == Variant::REAL) {
			int l = (int)laser;
			if (l == 0) {
				bullet->size = BULLET_SIZES[type];
			}

			else {
				bullet->size = (LASER_SIZES[type].x * (float)laser_width * 0.5f);
			}


			if (l == 1 || l == 2) {
				bullet->collision_type = 1;
				bullet->length = (float)laser_length;
				bullet->width = (float)laser_width;
				bullet->scale = (float)laser_width;
				bullet->clearance_front = LASER_SIZES[type].y;
				bullet->clearance_back = LASER_SIZES[type].z;
			}
			else if (l != 3) {
				bullet->collision_type = 0;
			}
		}

		if ((laser.get_type() == Variant::NIL) || ((laser.get_type() == Variant::INT || laser.get_type() == Variant::REAL) && (int)laser != 3)) {
			if (fade.get_type() == Variant::BOOL && ((bool)fade == true)) {
				if ((int)laser == 0) {
					bullet->fade_time = bullet->BULLET_FADE_TIME;
				}
				else if ((int)laser == 1) {
					bullet->fade_time = int((float)laser_length / bullet->speed);
				}
				bullet->fade_frames = bullet->fade_time;
				bullet->active = false;
			}
			else {
				bullet->active = true;
			}
		}
		if (bullet->animated) {
			bullet->anim_frame = (float)(rand() % bullet->anim_frame_max);
		}
	}
}

Array BulletManager::player_collision(Vector2 pos, float r1, float r2, bool focused, float piv) {
	bool hit = false;
	int graze = 0;

	PoolIntArray items_collected = PoolIntArray();
	for (int i = 0; i < 9; ++i) {
		items_collected.append(0);
	}

	Array active_bullets = Bullets->get("active_bullets");

	for (int i = 0; i < active_bullets.size(); ++i) {
		Bullet* b = active_bullets[i];
		if (!b->active) { continue; }
		if (!hit && pos.distance_squared_to(b->position) < (r1 + b->size) * (r1 + b->size)) {
			b->hit();
			hit = true;
		}
		if (!b->grazed && pos.distance_squared_to(b->position) < (r2 + b->size) * (r2 + b->size)) {
			b->grazed = true;
			graze += 1;
		}
	}
	Array loose_lasers = Bullets->get("loose_lasers");

	for (int i = 0; i < loose_lasers.size(); ++i) {
		Bullet* b = loose_lasers[i];
		if (!b->active) { continue; }
		Vector2 p1 = b->position;
		Vector2 p2 = p1 - b->direction * b->length;
		float min_x = p1.x + (p2.x - p1.x) * b->clearance_front;
		float max_x = p1.x + (p2.x - p1.x) * (1.0f - b->clearance_back - Math::max(float(b->fade_frames - 1) / b->fade_time, 0.0f));
		if (min_x > max_x) {
			float temp = min_x;
			min_x = max_x;
			max_x = temp;
		}
		float x_margin_graze = (b->size + r2) * abs(b->direction.y);
		//min_x -= (b->size + r2) * abs(b->direction.y);
		//max_x += (b->size + r2) * abs(b->direction.y);
		if (pos.x < min_x - x_margin_graze || pos.x > max_x + x_margin_graze) {
			continue;
		}

		float min_y = p1.y + (p2.y - p1.y) * b->clearance_front;
		float max_y = p1.y + (p2.y - p1.y) * (1.0f - b->clearance_back - Math::max(float(b->fade_frames - 1) / b->fade_time, 0.0f));
		if (min_y > max_y) {
			float temp = min_y;
			min_y = max_y;
			max_y = temp;
		}
		float y_margin_graze = (b->size + r2) * abs(b->direction.x);
		//min_y -= (b->size + r2) * abs(b->direction.x);
		//max_y += (b->size + r2) * abs(b->direction.x);
		if (pos.y < min_y - y_margin_graze || pos.y > max_y + y_margin_graze) {
			continue;
		}

		float x_margin = (b->size + r1) * abs(b->direction.y);
		float y_margin = (b->size + r1) * abs(b->direction.x);

		float numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y);
		float dist_squared = numerator * numerator / p1.distance_squared_to(p2);

		if (!hit && pos.x > (min_x - x_margin) && pos.x < (max_x + x_margin) && pos.y >(min_y - y_margin) && pos.y < (max_y + y_margin) && dist_squared < (r1 + b->size) * (r1 + b->size)) {
			b->hit();
			hit = true;
		}
		if (dist_squared < (r2 + b->size) * (r2 + b->size)) {
			b->graze_frame -= 1;
			if (b->graze_frame <= 0) {
				b->graze_frame = b->GRAZE_TIME;
				graze += 1;
			}
		}
	}
	Array straight_lasers = Bullets->get("straight_lasers");

	for (int i = 0; i < straight_lasers.size(); ++i) {
		Bullet* b = straight_lasers[i];
		if (!b->active) { continue; }
		Vector2 p1 = b->position;
		Vector2 p2 = p1 + b->direction * b->length;
		float min_x = p1.x + (p2.x - p1.x) * b->clearance_front;
		float max_x = p1.x + (p2.x - p1.x) * (1.0f - b->clearance_back - Math::max(float(b->fade_frames - 1) / b->fade_time, 0.0f));
		if (min_x > max_x) {
			float temp = min_x;
			min_x = max_x;
			max_x = temp;
		}
		float x_margin_graze = (b->size + r2) * abs(b->direction.y);
		//min_x -= (b->size + r2) * abs(b->direction.y);
		//max_x += (b->size + r2) * abs(b->direction.y);
		if (pos.x < min_x - x_margin_graze || pos.x > max_x + x_margin_graze) {
			continue;
		}

		float min_y = p1.y + (p2.y - p1.y) * b->clearance_front;
		float max_y = p1.y + (p2.y - p1.y) * (1.0f - b->clearance_back - Math::max(float(b->fade_frames - 1) / b->fade_time, 0.0f));
		if (min_y > max_y) {
			float temp = min_y;
			min_y = max_y;
			max_y = temp;
		}
		float y_margin_graze = (b->size + r2) * abs(b->direction.x);
		//min_y -= (b->size + r2) * abs(b->direction.x);
		//max_y += (b->size + r2) * abs(b->direction.x);
		if (pos.y < min_y - y_margin_graze || pos.y > max_y + y_margin_graze) {
			continue;
		}

		float x_margin = (b->size + r1) * abs(b->direction.y);
		float y_margin = (b->size + r1) * abs(b->direction.x);

		float numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y);
		float dist_squared = numerator * numerator / p1.distance_squared_to(p2);

		if (!hit && pos.x > (min_x - x_margin) && pos.x < (max_x + x_margin) && pos.y >(min_y - y_margin) && pos.y < (max_y + y_margin) && dist_squared < (r1 + b->size) * (r1 + b->size)) {
			b->hit();
			hit = true;
		}
		if (dist_squared < (r2 + b->size) * (r2 + b->size)) {
			b->graze_frame -= 1;
			if (b->graze_frame <= 0) {
				b->graze_frame = b->GRAZE_TIME;
				graze += 1;
			}
		}
	}
	Array active_items = Bullets->get("active_items");
	for (int j = 0; j < active_items.size(); ++j) {
		Item* i = active_items[j];
		if (pos.distance_squared_to(i->position) < (r1 + i->size) * (r1 + i->size)) {
			i->free = true;
			items_collected.set(i->type, items_collected[i->type] + 1);
			i->collect_position = i->position;
			if (i->type == 7) {//Point item
				if (i->max_value || pos.y < 350.0f) {
					i->point = piv;
				}
				else {
					i->point = 10.0f * floor(0.1f * piv * ((pos.y - 350.0f) / -1300.0f + 1.0f));
				}

				if (i->max_value || pos.y < 350.0f) {
					i->max_value_float = 1.0f;
				}
				else {
					i->max_value_float = 0.0f;
				}

			}
		}
		if (focused && pos.distance_squared_to(i->position) < (r2 + i->poc_size) * (r2 + i->poc_size)) {
			i->poced = true;
		}
	}

	/*
						for l in curve_lasers :
	for i in len(l.bullets) - 1 :
		var b = l.bullets[i]
		var p1 = b.position
		var p2 = l.bullets[i + 1].position

		if p1 == p2 :
			continue

			var min_x = p1.x
			var max_x = p2.x
			if min_x > max_x:
	var temp = min_x
		min_x = max_x
		max_x = temp
		#min_x -= (b.size + r2) * abs(b.direction.y)
		#max_x += (b.size + r2) * abs(b.direction.y)
		var x_margin_graze = (b.size + r2) * abs(b.direction.y)
		if pos.x < (min_x - x_margin_graze) || pos.x >(max_x + x_margin_graze) :
			continue

			var min_y = p1.y
			var max_y = p2.y
			if min_y > max_y:
	var temp = min_y
		min_y = max_y
		max_y = temp
		#min_y -= (b.size + r2) * abs(b.direction.x)
		#max_y += (b.size + r2) * abs(b.direction.x)
		var y_margin_graze = (b.size + r2) * abs(b.direction.x)
		if pos.y < (min_y - y_margin_graze) || pos.y >(max_y + y_margin_graze) :
			continue

			var x_margin = (b.size + r1) * abs(b.direction.y)
			var y_margin = (b.size + r1) * abs(b.direction.x)

			var numerator = (p2.x - p1.x) * (p1.y - pos.y) - (p1.x - pos.x) * (p2.y - p1.y)
			var dist_squared = numerator * numerator / p1.distance_squared_to(p2)

			if !hit && pos.x > (min_x - x_margin) && pos.x < (max_x + x_margin) && pos.y >(min_y - y_margin) && pos.y < (max_y + y_margin) && dist_squared < (r1 + b.size)* (r1 + b.size) :
				b.hit()
				hit = true
				if !b.grazed&& dist_squared < (r2 + b.size)* (r2 + b.size) :
					l.grazed = true
					b.grazed = true
					#graze()
					graze += 1
					root.graze += 1

					for i in active_items :
	if pos.distance_squared_to(i.position) < (r1 + i.size)* (r1 + i.size) :
		i.free = true
		items_collected[i.type] += 1
		i.collect_position = i.position
		if i.type == ITEM.POINT :
			i.point = root.piv if i.max_value || pos.y < 350.0 else 10.0 * floor(0.1 * root.piv * ((pos.y - 350.0) / -1300.0 + 1.0))
			i.max_value_float = 1.0 if i.max_value || pos.y < 350.0 else 0.0

			if focused&& pos.distance_squared_to(i.position) < (r2 + i.poc_size)* (r2 + i.poc_size) :
				i.poced = true

				return[hit, graze, items_collected]

*/

	Array ret_arr = Array();
	ret_arr.append(hit);
	ret_arr.append(graze);
	ret_arr.append(items_collected);
	return ret_arr;
}

void BulletManager::move_bullets()
{
	Array active_bullets = Bullets->get("active_bullets");

	for (int a = 0; a < active_bullets.size(); ++a) {
		Bullet* b = (Bullet*)active_bullets[a];
		b->move_bullet();
		int i = 0;
		int j = 0;
		int loop_times = b->transform_queue.size();
		while (i < loop_times) {
			Array l_t = b->transform_queue[i];
			b->transform_queue[j] = l_t;
			Array t = b->transform_queue[j];
			if (t.size() > 0 && t[0].get_type() == Variant::INT) {
				int t_cond = t[0];
				if (t_cond == 0 || t_cond == -1) {
					transform_bullet(b, t);
				}
				else if (t_cond == -2) {
					if (b->grazed && !b->already_grazed) {
						transform_bullet(b, t);
					}
					else {
						j += 1;
					}
				}
				else if (t_cond == -3) {
					if (b->bounced) {
						transform_bullet(b, t);
					}
					else {
						j += 1;
					}
				}
				else if (t_cond == -4) {
					if (b->warped) {
						transform_bullet(b, t);
					}
					else {
						j += 1;
					}	
				}
				else {
					t[0] = t_cond - 1;
					j += 1;
				}
				if (b->grazed) {
					b->already_grazed = true;
				}

			}
			
			i += 1;
		}
		for (int k = 0; k < i - j; ++k) {
			b->transform_queue.pop_back();
		}

	}

}


