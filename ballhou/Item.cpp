#include "Item.h"

void Item::_register_methods()
{
	register_property("position", &Item::position, Vector2());
	register_property("spin", &Item::spin, 1.0f);
	register_property("angle", &Item::angle, 0.0f);
	register_property("direction", &Item::direction, Vector2());
	register_property("DAMP", &Item::DAMP, 0.9f);
	register_property("up_speed", &Item::up_speed, 24.0f);
	register_property("speed", &Item::speed, 2.0f);
	register_property("type", &Item::type, 0.0f);
	register_property("size", &Item::size, 64.0f);
	register_property("poc_size", &Item::poc_size, 128.0f);
	register_property("scale", &Item::scale, 64.0f);
	register_property("spawn_timer", &Item::spawn_timer, 45);
	register_property("poced", &Item::poced, false);
	register_property("max_value", &Item::max_value, false);
	register_property("free", &Item::free, false);

	register_property("collect_position", &Item::collect_position, Vector2());
	register_property("collect_timer", &Item::collect_timer, 1.0f);
	register_property("point", &Item::point, 0.0f);
	register_property("max_value_float", &Item::max_value_float, 0.0f);
}

void Item::_init()
{
}
