extends Spatial

var last_anim = ''


var root: Node2D

func flash():
	$AnimationPlayer.play("flash")



func _on_AnimationPlayer_animation_finished(anim_name):
	last_anim = anim_name
	$temptimer.start()
	

func _on_temptimer_timeout():
	if last_anim == '':
		$AnimationPlayer.play("dive")
	elif last_anim == "dive":
		$AnimationPlayer.play("enterbarn")
	elif last_anim == "enterbarn":
		$AnimationPlayer.play("exitbarn")
	elif last_anim == "exitbarn":
		$AnimationPlayer.play("spin")

func _process(delta):
	if !root:
		root = Globals.root
	if root.bg_flag:
		match root.bg_flag:
			1:
				$AnimationPlayer.play("dive")
			2:
				$AnimationPlayer.play("enterbarn")
			3:
				$AnimationPlayer.play("exitbarn")
			4:
				$AnimationPlayer.play("spin")
		
		root.bg_flag = 0
