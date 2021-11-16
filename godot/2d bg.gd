extends Node2D


var root: Node2D

func _ready():
	if Globals.BG_TYPE != 1:
		queue_free()

func _process(delta):
	if !root:
		root = Globals.root
	else:
		match root.bg_flag:
			1:
				$AnimationPlayer.play("dive")
			2:
				$AnimationPlayer.play("enter")
			3:
				$AnimationPlayer.play("exit")
		
		root.bg_flag = 0

