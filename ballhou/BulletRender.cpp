#include "BulletRender.h"

float BulletRender::s(float t)
{
	if (t < 0.25) {
		return t * 10.0;
	}
	return 2.5 - (t - 0.25) * 2;
}

void BulletRender::_register_methods()
{
	register_method("_ready", &BulletRender::_ready);
	register_method("_process", &BulletRender::_process);


	register_property("BulletsPath", &BulletRender::BulletsPath, NodePath());
	register_property("BulletRendererPath", &BulletRender::BulletRendererPath, NodePath());
	register_property("BulletRendererUpperPath", &BulletRender::BulletRendererUpperPath, NodePath());
	register_property("BulletRendererAddPath", &BulletRender::BulletRendererAddPath, NodePath());
	register_property("BulletClearPath", &BulletRender::BulletClearPath, NodePath());
	register_property("ItemRendererPath", &BulletRender::ItemRendererPath, NodePath());
	register_property("ItemTextRendererPath", &BulletRender::ItemTextRendererPath, NodePath());
}

void BulletRender::_init()
{
}

void BulletRender::_ready()
{
	Bullets = get_node(BulletsPath);
	MultiMeshInstance2D* BulletRenderer = (MultiMeshInstance2D*)get_node(BulletRendererPath);
	BulletRendererMesh = BulletRenderer->get_multimesh();
	MultiMeshInstance2D* BulletRendererUpper = (MultiMeshInstance2D*)get_node(BulletRendererUpperPath);
	BulletRendererUpperMesh = BulletRendererUpper->get_multimesh();
	MultiMeshInstance2D* BulletRendererAdd = (MultiMeshInstance2D*)get_node(BulletRendererAddPath);
	BulletRendererAddMesh = BulletRendererAdd->get_multimesh();
	MultiMeshInstance2D* BulletClear = (MultiMeshInstance2D*)get_node(BulletClearPath);
	BulletClearMesh = BulletClear->get_multimesh();
	MultiMeshInstance2D* ItemRenderer = (MultiMeshInstance2D*)get_node(ItemRendererPath);
	ItemRendererMesh = ItemRenderer->get_multimesh();
	MultiMeshInstance2D* ItemTextRenderer = (MultiMeshInstance2D*)get_node(ItemTextRendererPath);
	ItemTextRendererMesh = ItemTextRenderer->get_multimesh();
}

void BulletRender::_process(float delta)
{
	BulletRendererMesh->set_visible_instance_count(10000);
	BulletRendererUpperMesh->set_visible_instance_count(10000);
	BulletRendererAddMesh->set_visible_instance_count(10000);
	BulletClearMesh->set_visible_instance_count(10000);
	int count_alpha = 0;
	int count_alpha_upper = 0;
	int count_add = 0;
	int count_clear = 0;
	PoolRealArray array_alpha = PoolRealArray();
	PoolRealArray array_alpha_upper = PoolRealArray();
	PoolRealArray array_add = PoolRealArray();
	PoolRealArray array_clear = PoolRealArray();
	array_alpha.resize(10000 * 16);
	array_alpha_upper.resize(10000 * 16);
	array_add.resize(10000 * 16);
	array_clear.resize(10000 * 12);

	// Bullets

	Array active_bullets = Bullets->get("active_bullets");

	for (int i = 0; i < active_bullets.size(); ++i) {
		Bullet* b = (Bullet*)active_bullets[i];
		if (b->visible) {
			Color uv = b->uv;
			if (b->animated) {
				b->anim_frame += b->anim_step;
				if (b->anim_frame >= b->anim_frame_max) {
					b->anim_frame = 0.0;
				}
				uv.r += uv.b * std::floor(b->anim_frame);
			}
			float angle = b->sprite_angle;
			angle -= 1.57079632679;
			if (b->no_rotate) {
				angle = 0.0;
			}

			float fade_frames = b->fade_frames;
			float fade_time = b->fade_time;
			float interp = std::max((fade_frames - 1.0) / fade_time, 0.0);
			float scale = s(1.0 - interp);
			float b_scale = b->scale;
			Vector2 b_position = b->position;

			if (b->blend == 0) {
				if (b->layer == 0) {
					array_alpha.set(count_alpha * 16, 1.0);
					array_alpha.set(count_alpha * 16 + 1, 0.0);
					array_alpha.set(count_alpha * 16 + 3, b_position.x);
					array_alpha.set(count_alpha * 16 + 4, 0.0);
					array_alpha.set(count_alpha * 16 + 5, 1.0);
					array_alpha.set(count_alpha * 16 + 7, b_position.y);
					array_alpha.set(count_alpha * 16 + 8, angle);
					array_alpha.set(count_alpha * 16 + 9, b->offset);
					array_alpha.set(count_alpha * 16 + 10, b_scale * scale);
					array_alpha.set(count_alpha * 16 + 11, 1.0 - interp);
					array_alpha.set(count_alpha * 16 + 12, uv.r);
					array_alpha.set(count_alpha * 16 + 13, uv.g);
					array_alpha.set(count_alpha * 16 + 14, uv.b);
					array_alpha.set(count_alpha * 16 + 15, uv.a);
					count_alpha += 1;
				} else {
					array_alpha_upper.set(count_alpha_upper * 16, 1.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 1, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 3, b_position.x);
					array_alpha_upper.set(count_alpha_upper * 16 + 4, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 5, 1.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 7, b_position.y);
					array_alpha_upper.set(count_alpha_upper * 16 + 8, angle);
					array_alpha_upper.set(count_alpha_upper * 16 + 9, b->offset);
					array_alpha_upper.set(count_alpha_upper * 16 + 10, b_scale * scale);
					array_alpha_upper.set(count_alpha_upper * 16 + 11, 1.0 - interp);
					array_alpha_upper.set(count_alpha_upper * 16 + 12, uv.r);
					array_alpha_upper.set(count_alpha_upper * 16 + 13, uv.g);
					array_alpha_upper.set(count_alpha_upper * 16 + 14, uv.b);
					array_alpha_upper.set(count_alpha_upper * 16 + 15, uv.a);
					count_alpha_upper += 1;
				}
			}
			else {
				array_add.set(count_add * 16, 1.0);
				array_add.set(count_add * 16 + 1, 0.0);
				array_add.set(count_add * 16 + 3, b_position.x);
				array_add.set(count_add * 16 + 4, 0.0);
				array_add.set(count_add * 16 + 5, 1.0);
				array_add.set(count_add * 16 + 7, b_position.y);
				array_add.set(count_add * 16 + 8, angle);
				array_add.set(count_add * 16 + 9, b->offset);
				array_add.set(count_add * 16 + 10, b_scale * scale);
				array_add.set(count_add * 16 + 11, 1.0 - interp);
				array_add.set(count_add * 16 + 12, uv.r);
				array_add.set(count_add * 16 + 13, uv.g);
				array_add.set(count_add * 16 + 14, uv.b);
				array_add.set(count_add * 16 + 15, uv.a);
				count_add += 1;
			}
		}
	}

	// Loose Lasers

	Array loose_lasers = Bullets->get("loose_lasers");

	for (int i = 0; i < loose_lasers.size(); ++i) {
		Bullet* b = (Bullet*)loose_lasers[i];
		if (b->visible) {
			Color uv = b->uv;
			if (b->animated) {
				b->anim_frame += b->anim_step;
				if (b->anim_frame >= b->anim_frame_max) {
					b->anim_frame = 0.0;
				}
				uv.r += uv.b * std::floor(b->anim_frame);
			}
			float angle = b->sprite_angle - 1.57079632679;

			float fade_frames = b->fade_frames;
			float fade_time = b->fade_time;
			float interp = std::max((fade_frames - 1.0) / fade_time, 0.0);
			float scale = 1.0 - interp;
			float b_scale = b->scale;
			float b_length = b->length;
			Vector2 b_position = b->position;

			Transform2D xform(b->width, 0.0f, 0.0f, b_length * scale, 0.0f, 0.0f);
			xform.rotate(angle);
			xform.set_origin(b_position - Vector2(0.0, b_length * 0.5 * scale).rotated(angle));

			if (b->blend == 0) {
				if (b->layer == 0) {
					array_alpha.set(count_alpha * 16, xform[0].x);
					array_alpha.set(count_alpha * 16 + 1, xform[1].x);
					array_alpha.set(count_alpha * 16 + 3, xform[2].x);
					array_alpha.set(count_alpha * 16 + 4, xform[0].y);
					array_alpha.set(count_alpha * 16 + 5, xform[1].x);
					array_alpha.set(count_alpha * 16 + 7, xform[2].x);
					array_alpha.set(count_alpha * 16 + 8, 0.0);
					array_alpha.set(count_alpha * 16 + 9, 0.0);
					array_alpha.set(count_alpha * 16 + 10, 1.0);
					array_alpha.set(count_alpha * 16 + 11, 1.0);
					array_alpha.set(count_alpha * 16 + 12, uv.r);
					array_alpha.set(count_alpha * 16 + 13, uv.g);
					array_alpha.set(count_alpha * 16 + 14, uv.b);
					array_alpha.set(count_alpha * 16 + 15, uv.a);
					count_alpha += 1;
				}
				else {
					array_alpha_upper.set(count_alpha_upper * 16, xform[0].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 1, xform[1].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 3, xform[2].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 4, xform[0].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 5, xform[1].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 7, xform[2].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 8, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 9, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 10, 1.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 11, 1.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 12, uv.r);
					array_alpha_upper.set(count_alpha_upper * 16 + 13, uv.g);
					array_alpha_upper.set(count_alpha_upper * 16 + 14, uv.b);
					array_alpha_upper.set(count_alpha_upper * 16 + 15, uv.a);
					count_alpha_upper += 1;
				}

			}
			else {
				array_add.set(count_add * 16, xform[0].x);
				array_add.set(count_add * 16 + 1, xform[1].x);
				array_add.set(count_add * 16 + 3, xform[2].x);
				array_add.set(count_add * 16 + 4, xform[0].y);
				array_add.set(count_add * 16 + 5, xform[1].y);
				array_add.set(count_add * 16 + 7, xform[2].y);
				array_add.set(count_add * 16 + 8, 0.0);
				array_add.set(count_add * 16 + 9, 0.0);
				array_add.set(count_add * 16 + 10, 1.0);
				array_add.set(count_add * 16 + 11, 1.0);
				array_add.set(count_add * 16 + 12, uv.r);
				array_add.set(count_add * 16 + 13, uv.g);
				array_add.set(count_add * 16 + 14, uv.b);
				array_add.set(count_add * 16 + 15, uv.a);
				count_add += 1;
			}
			if (interp > 0.0) {
				uv = b->laser_spawn_uv;

				array_add.set(count_add * 16, 1.0);
				array_add.set(count_add * 16 + 1, 0.0);
				array_add.set(count_add * 16 + 3, b_position.x - b->length * b->direction.x * scale);
				array_add.set(count_add * 16 + 4, 0.0);
				array_add.set(count_add * 16 + 5, 1.0);
				array_add.set(count_add * 16 + 7, b_position.y - b->length * b->direction.y * scale);
				array_add.set(count_add * 16 + 8, 360.0 * rand() / (RAND_MAX + 1.0));
				array_add.set(count_add * 16 + 9, b->offset);
				array_add.set(count_add * 16 + 10, b->scale * 2.0);
				array_add.set(count_add * 16 + 11, 1.0);
				array_add.set(count_add * 16 + 12, uv.r);
				array_add.set(count_add * 16 + 13, uv.g);
				array_add.set(count_add * 16 + 14, uv.b);
				array_add.set(count_add * 16 + 15, uv.a);
				count_add += 1;
			}
		}
	}


	// Straight Lasers

	Array straight_lasers = Bullets->get("straight_lasers");

	for (int i = 0; i < straight_lasers.size(); ++i) {
		Bullet* b = (Bullet*)straight_lasers[i];
		if (b->visible) {
			Color uv = b->uv;
			if (b->animated) {
				b->anim_frame += b->anim_step;
				if (b->anim_frame >= b->anim_frame_max) {
					b->anim_frame = 0.0;
				}
				uv.r += uv.b * std::floor(b->anim_frame);
			}
			float angle = b->angle - 1.57079632679;

			float fade_frames = b->fade_frames;
			float fade_time = b->fade_time;
			float interp = std::min(std::max(fade_frames / fade_time, 0.0f), 1.0f);
			float scale = (1.0 - interp) * 0.75 + 0.25;
			float alpha = 1.0;
			if (b->laser_complete) {
				scale = interp;
				alpha = interp;
			}
			float b_scale = b->scale;
			float b_length = b->length;
			Vector2 b_position = b->position;

			Transform2D xform(b->width * scale, 0.0f, 0.0f, b_length, 0.0f, 0.0f);
			xform.rotate(angle);
			xform.set_origin(b_position + Vector2(0.0, b_length * 0.5).rotated(angle));

			if (b->blend == 0) {
				if (b->layer == 0) {
					array_alpha.set(count_alpha * 16, xform[0].x);
					array_alpha.set(count_alpha * 16 + 1, xform[1].x);
					array_alpha.set(count_alpha * 16 + 3, xform[2].x);
					array_alpha.set(count_alpha * 16 + 4, xform[0].y);
					array_alpha.set(count_alpha * 16 + 5, xform[1].x);
					array_alpha.set(count_alpha * 16 + 7, xform[2].x);
					array_alpha.set(count_alpha * 16 + 8, 0.0);
					array_alpha.set(count_alpha * 16 + 9, 0.0);
					array_alpha.set(count_alpha * 16 + 10, 1.0);
					array_alpha.set(count_alpha * 16 + 11, alpha);
					array_alpha.set(count_alpha * 16 + 12, uv.r);
					array_alpha.set(count_alpha * 16 + 13, uv.g);
					array_alpha.set(count_alpha * 16 + 14, uv.b);
					array_alpha.set(count_alpha * 16 + 15, uv.a);
					count_alpha += 1;
				} else {
					array_alpha_upper.set(count_alpha_upper * 16, xform[0].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 1, xform[1].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 3, xform[2].x);
					array_alpha_upper.set(count_alpha_upper * 16 + 4, xform[0].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 5, xform[1].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 7, xform[2].y);
					array_alpha_upper.set(count_alpha_upper * 16 + 8, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 9, 0.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 10, 1.0);
					array_alpha_upper.set(count_alpha_upper * 16 + 11, alpha);
					array_alpha_upper.set(count_alpha_upper * 16 + 12, uv.r);
					array_alpha_upper.set(count_alpha_upper * 16 + 13, uv.g);
					array_alpha_upper.set(count_alpha_upper * 16 + 14, uv.b);
					array_alpha_upper.set(count_alpha_upper * 16 + 15, uv.a);
					count_alpha_upper += 1;
				}
			}
			else {
				array_add.set(count_add * 16, xform[0].x);
				array_add.set(count_add * 16 + 1, xform[1].x);
				array_add.set(count_add * 16 + 3, xform[2].x);
				array_add.set(count_add * 16 + 4, xform[0].y);
				array_add.set(count_add * 16 + 5, xform[1].y);
				array_add.set(count_add * 16 + 7, xform[2].y);
				array_add.set(count_add * 16 + 8, 0.0);
				array_add.set(count_add * 16 + 9, 0.0);
				array_add.set(count_add * 16 + 10, 1.0);
				array_add.set(count_add * 16 + 11, alpha);
				array_add.set(count_add * 16 + 12, uv.r);
				array_add.set(count_add * 16 + 13, uv.g);
				array_add.set(count_add * 16 + 14, uv.b);
				array_add.set(count_add * 16 + 15, uv.a);
				count_add += 1;
			}

			uv = b->laser_spawn_uv;

			array_add.set(count_add * 16, 1.0);
			array_add.set(count_add * 16 + 1, 0.0);
			array_add.set(count_add * 16 + 3, b_position.x);
			array_add.set(count_add * 16 + 4, 0.0);
			array_add.set(count_add * 16 + 5, 1.0);
			array_add.set(count_add * 16 + 7, b_position.y);
			array_add.set(count_add * 16 + 8, 360.0 * rand() / (RAND_MAX + 1.0));
			array_add.set(count_add * 16 + 9, b->offset);
			array_add.set(count_add * 16 + 10, b->scale * (scale * 0.75 + 1.5));
			array_add.set(count_add * 16 + 11, alpha);
			array_add.set(count_add * 16 + 12, uv.r);
			array_add.set(count_add * 16 + 13, uv.g);
			array_add.set(count_add * 16 + 14, uv.b);
			array_add.set(count_add * 16 + 15, uv.a);
			count_add += 1;
		}
	}


	// Clear Bullets

	Array clearing_bullets = Bullets->get("clearing_bullets");

	for (int i = 0; i < clearing_bullets.size(); ++i) {
		Bullet* b = (Bullet*)clearing_bullets[i];
		
		Color fade_colour = b->fade_colour;
		float frame = b->CLEAR_TIME - std::floor(b->clear_timer);

		Vector2 p = b->fade_position / b->fade_scale;
		Transform2D xform(b->fade_angle, Vector2(p.x * b->fade_lr, p.y));
		xform.scale(Vector2(b->fade_lr, 1.0) * b->fade_scale);

		array_clear.set(count_clear * 12, xform[0].x);
		array_clear.set(count_clear * 12 + 1, xform[1].x);
		array_clear.set(count_clear * 12 + 3, xform[2].x);
		array_clear.set(count_clear * 12 + 4, xform[0].y);
		array_clear.set(count_clear * 12 + 5, xform[1].y);
		array_clear.set(count_clear * 12 + 7, xform[2].y);
		array_clear.set(count_clear * 12 + 8, fade_colour.r);
		array_clear.set(count_clear * 12 + 9, fade_colour.g);
		array_clear.set(count_clear * 12 + 10, fade_colour.b);
		array_clear.set(count_clear * 12 + 11, frame);

		count_clear += 1;
		p = b->fade_position / (b->fade_scale * 2.0);
		xform = Transform2D(b->fade_angle, Vector2(-p.x * b->fade_lr, p.y));
		xform.scale(Vector2(-b->fade_lr, 1.0)* b->fade_scale * 2.0);

		array_clear.set(count_clear * 12, xform[0].x);
		array_clear.set(count_clear * 12 + 1, xform[1].x);
		array_clear.set(count_clear * 12 + 3, xform[2].x);
		array_clear.set(count_clear * 12 + 4, xform[0].y);
		array_clear.set(count_clear * 12 + 5, xform[1].y);
		array_clear.set(count_clear * 12 + 7, xform[2].y);
		array_clear.set(count_clear * 12 + 8, fade_colour.r);
		array_clear.set(count_clear * 12 + 9, fade_colour.g);
		array_clear.set(count_clear * 12 + 10, fade_colour.b);
		array_clear.set(count_clear * 12 + 11, frame);

		count_clear += 1;
	}


	BulletRendererMesh->set_as_bulk_array(array_alpha);
	BulletRendererUpperMesh->set_as_bulk_array(array_alpha_upper);
	BulletRendererAddMesh->set_as_bulk_array(array_add);
	BulletClearMesh->set_as_bulk_array(array_clear);
	BulletRendererMesh->set_visible_instance_count(count_alpha);
	BulletRendererUpperMesh->set_visible_instance_count(count_alpha_upper);
	BulletRendererAddMesh->set_visible_instance_count(count_add);
	BulletClearMesh->set_visible_instance_count(count_clear);

	Array curve_lasers = Bullets->get("curve_lasers");

	for (int i = 0; i < curve_lasers.size(); ++i) {
		CurveLaser* laser = curve_lasers[i];
		if (laser->visible) {
			if (laser->animated) {
				laser->anim_frame += laser->anim_step;
					if (laser->anim_frame >= laser->anim_frame_max) {
						laser->anim_frame = 0;
					}
			}
			int surface_count = laser->mesh->get_surface_count();
			for (int j = 0; j < surface_count; ++j) {
				laser->mesh->surface_remove(surface_count - 1 - j);
			}

			//Ref<SurfaceTool> st = SurfaceTool::_new();
			//st->begin(5);

			int vert_size = laser->verts.size();

			PoolVector2Array uvs = laser->uvs;

			if (laser->animated) {
				for (int k = 0; k < vert_size; ++k) {
					uvs.set(k, uvs[k] + Vector2(laser->uv.b * floor(laser->anim_frame), 0));
					//st->add_uv(laser->uvs[i] + Vector2(laser->uv.b * floor(laser->anim_frame), 0));
					//st->add_vertex(laser->verts[i]);
				}
			}
			Array arr = Array();
			arr.resize(9);
			arr[0] = laser->verts;
			arr[4] = uvs;
			laser->mesh->add_surface_from_arrays(5, arr, Array(), 97280 + 262144);
			//st->commit(laser->mesh, 97280 + 262144);
		}
	}

	ItemRendererMesh->set_visible_instance_count(4096);
	int count = 0;
	PoolRealArray arr = PoolRealArray();
	arr.resize(4096 * 12);

	Array active_items = Bullets->get("active_items");

	for (int i = 0; i < active_items.size(); ++i) {
		Item* item = (Item*)active_items[i];

		arr.set(count * 12, 1.0);
		arr.set(count * 12 + 1, 0.0);
		arr.set(count * 12 + 3, item->position.x);
		arr.set(count * 12 + 4, 0.0);
		arr.set(count * 12 + 5, 1.0);
		arr.set(count * 12 + 7, (item->position.y > -item->size) ? item->position.y : 40.0);
		arr.set(count * 12 + 8, item->type);
		arr.set(count * 12 + 9, (item->position.y > -item->size) ? 0.0 : 0.5);
		arr.set(count * 12 + 10, (item->position.y > -item->size) ? item->scale : item->OFFSCREEN_SCALE);
		arr.set(count * 12 + 11, (item->position.y > -item->size) ? item->angle : 0.0);
		count += 1;

	}
	ItemRendererMesh->set_as_bulk_array(arr);
	ItemRendererMesh->set_visible_instance_count(count);
	
	ItemTextRendererMesh->set_visible_instance_count(4096);
	count = 0;
	arr = PoolRealArray();
	arr.resize(4096 * 12);

	Array collected_items = Bullets->get("collected_items");

	for (int i = 0; i < collected_items.size(); ++i) {
		Item* item = (Item*)collected_items[i];

		arr.set(count * 12, 1.0);
		arr.set(count * 12 + 1, 0.0);
		arr.set(count * 12 + 3, item->collect_position.x);
		arr.set(count * 12 + 4, 0.0);
		arr.set(count * 12 + 5, 1.0);
		arr.set(count * 12 + 7, item->collect_position.y);
		arr.set(count * 12 + 8, item->point);
		arr.set(count * 12 + 9, item->collect_timer);
		arr.set(count * 12 + 10, item->max_value_float);
		count += 1;

	}
	ItemTextRendererMesh->set_as_bulk_array(arr);
	ItemTextRendererMesh->set_visible_instance_count(count);

}

/*
* 
	for laser in []:
		if laser.visible:
			if laser.animated:
				laser.anim_frame += laser.anim_step
				if laser.anim_frame >= laser.anim_frame_max:
					laser.anim_frame = 0
			
			#print(laser.get_mesh())
			var surface_count = laser.mesh.get_surface_count()
			for i in surface_count:
				laser.mesh.surface_remove(surface_count-1 - i)
			
			var st = SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
			
			if laser.animated:
				for i in len(laser.verts):
					st.add_uv(laser.uvs[i] + Vector2(laser.uv.b * floor(laser.anim_frame), 0))
					st.add_vertex(laser.verts[i])
			else:
				for i in len(laser.verts):
					st.add_uv(laser.uvs[i])
					st.add_vertex(laser.verts[i])
			st.commit(laser.mesh, 97280 + 262144)
* 
# TODO: offload to GPU stuff
func draw_bullets():
	for b in active_bullets:
		if b.visible:
			var uv = b.uv
			if b.animated:
				b.anim_frame += b.anim_step
				if b.anim_frame >= b.anim_frame_max:
					b.anim_frame = 0
				uv.r += uv.b * floor(b.anim_frame)
			
			var angle = b.sprite_angle-PI*0.5
			if b.type in Constants.NO_ROTATE_BULLETS:
				angle = 0.0
			
			var interp = max(float(b.fade_frames-1) / b.fade_time, 0.0)
			var scale = s(1-interp)

			array_alpha.set(count_alpha*16, 1.0)
			array_alpha.set(count_alpha*16+1, 0.0)
			array_alpha.set(count_alpha*16+3, b.position.x)
			array_alpha.set(count_alpha*16+4, 0.0)
			array_alpha.set(count_alpha*16+5, 1.0)
			array_alpha.set(count_alpha*16+7, b.position.y)
			array_alpha.set(count_alpha*16+8, angle)
			array_alpha.set(count_alpha*16+9, b.offset)
			array_alpha.set(count_alpha*16+10, b.scale * scale)
			array_alpha.set(count_alpha*16+11, 1.0-interp)
			array_alpha.set(count_alpha*16+12, uv.r)
			array_alpha.set(count_alpha*16+13, uv.g)
			array_alpha.set(count_alpha*16+14, uv.b)
			array_alpha.set(count_alpha*16+15, uv.a)
			count_alpha += 1
	BulletRenderer.multimesh.set_as_bulk_array(array_alpha)
	BulletRenderer.multimesh.visible_instance_count = count_alpha
	*/