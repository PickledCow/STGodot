extends Node2D

var texture = preload("res://bullet/bullet.png")

export var add = false

onready var Bullets = get_node("../BulletHandler")


func _process(delta):
	update()
	
func _draw():
	for laser in Bullets.curve_lasers:
		if (laser.blend == BLEND_MODE_ADD) == add:
			draw_mesh(laser.mesh, texture)


