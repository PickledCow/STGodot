extends Spatial

var last_anim = ''

var root: Node2D

func flash():
	$AnimationPlayer.play("flash")


func _on_AnimationPlayer_animation_finished(anim_name):
	last_anim = anim_name
	$Timer.start()
	

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


func _on_Timer_timeout():
	if last_anim == "exitbarn":
		$AnimationPlayer.play("spin")
