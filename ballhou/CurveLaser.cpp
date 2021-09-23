#include "CurveLaser.h"

void CurveLaser::_register_methods()
{
	register_method("get_mesh", &CurveLaser::get_mesh);
	register_method("set_mesh", &CurveLaser::set_mesh);

	register_property("grazed", &CurveLaser::grazed, false);
	register_property("already_grazed", &CurveLaser::already_grazed, false);

	register_property("length", &CurveLaser::length, 0.0f);
	register_property("start_index", &CurveLaser::start_index, 0);
	register_property("points", &CurveLaser::points, PoolVector2Array());
	register_property("verts", &CurveLaser::verts, PoolVector3Array());
	register_property("uvs", &CurveLaser::uvs, PoolVector2Array());
	register_property("sample_rate", &CurveLaser::sample_rate, 0);
	register_property("bullets", &CurveLaser::bullets, Array());
	register_property("size", &CurveLaser::size, 0.0f);
	register_property("width", &CurveLaser::width, 0.0f);
	register_property("clearance_back", &CurveLaser::clearance_back, 0.0f);
	register_property("clearance_front", &CurveLaser::clearance_front, 0.0f);;
	register_property("free", &CurveLaser::free, true);

	register_property("direction", &CurveLaser::direction, Vector2());
	register_property("speed", &CurveLaser::speed, 0.0f);
	register_property("angle", &CurveLaser::angle, 0.0f);
	register_property("accel", &CurveLaser::accel, 0.0f);
	register_property("max_speed", &CurveLaser::max_speed, 0.0f);
	register_property("w_vel", &CurveLaser::w_vel, 0.0f);
	register_property("acc_vector", &CurveLaser::acc_vector, Vector2());
	register_property("vel_max_vector", &CurveLaser::vel_max_vector, Vector2());

	register_property("mesh", &CurveLaser::mesh, Ref<ArrayMesh>());

	register_property("srect", &CurveLaser::srect, Rect2());
	register_property("texture_rect", &CurveLaser::texture_rect, Rect2());

	register_property("type", &CurveLaser::type, 0);
	register_property("colour", &CurveLaser::colour, 0);

	register_property("visible", &CurveLaser::visible, true);
	register_property("uv", &CurveLaser::uv, Color());
	register_property("scale", &CurveLaser::scale, 0.0f);
	register_property("blend", &CurveLaser::blend, 0);
	register_property("laser_spawn_uv", &CurveLaser::laser_spawn_uv, Color());

	register_property("anim_frame_max", &CurveLaser::anim_frame_max, 4);
	register_property("animated", &CurveLaser::animated, false);
	register_property("anim_step", &CurveLaser::anim_step, 0.3334f);
	register_property("anim_width", &CurveLaser::anim_width, 32.0f);
	register_property("anim_frame", &CurveLaser::anim_frame, 0.0f);

	register_property("active", &CurveLaser::active, false);

	register_property("BULLET_FADE_TIME", &CurveLaser::BULLET_FADE_TIME, 0);
	register_property("fade_time", &CurveLaser::fade_time, 8);
	register_property("fade_frames", &CurveLaser::fade_frames, 0);

	register_property("transform_queue", &CurveLaser::transform_queue, Array());
	register_property("spawn_time", &CurveLaser::spawn_time, 0);

}

void CurveLaser::_init()
{
	//mesh = Ref<ArrayMesh>();
}


Ref<ArrayMesh> CurveLaser::get_mesh() const
{
	//Godot::print(mesh->ARRAY_FORMAT_VERTEX);
	return mesh;
}
void CurveLaser::set_mesh(const Ref<ArrayMesh> &m)
{
	mesh = m;
}

