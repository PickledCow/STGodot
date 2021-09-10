extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$AnimationPlayer.play("main")

func _input(event):
	if event.is_action_pressed("bomb"):
		$AnimationPlayer.play("main")
	

