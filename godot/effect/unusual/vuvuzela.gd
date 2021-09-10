extends Node2D



func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.pitch_scale = 1.0/rand_range(0.9,1.1)


func _on_AudioStreamPlayer2_finished():
	$AudioStreamPlayer2.play()
	$AudioStreamPlayer2.pitch_scale = 1.0/rand_range(0.9,1.1)


func _on_Timer_timeout():
	$AudioStreamPlayer2.play()
	$AudioStreamPlayer2.pitch_scale = 1.0/rand_range(0.9,1.1)
