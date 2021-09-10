extends Spatial

var last_anim = ''

func flash():
	$AnimationPlayer.play("flash")

func _ready():
	$temptimer.start()


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
