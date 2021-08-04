extends ColorRect

var pos = Vector2()

func _ready():
	material.set_shader_param('size', 0.0)

func warp(p, s):
	pos = Vector2((p.x)/1000.0, 1.0-(p.y)/1000.0)
	material.set_shader_param('centre', pos)
	var speed = s * 60.0 / 1000.0
	$AnimationPlayer.play("main", -1, speed)
