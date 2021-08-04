
#include "Common.h"
#include "BulletRender.h"
#include "BulletManager.h"
#include "Bullet.h"
#include "CurveLaser.h"
#include "Item.h"

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options * o) {
	godot::Godot::gdnative_init(o);
}

extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options * o) {
	godot::Godot::gdnative_terminate(o);
}

extern "C" void GDN_EXPORT godot_nativescript_init(void* handle) {
	godot::Godot::nativescript_init(handle);

	godot::register_class<BulletRender>();
	godot::register_class<BulletManager>();
	godot::register_class<Bullet>();
	godot::register_class<CurveLaser>();
	godot::register_class<Item>();
}
