extends Node2D


var Player : Node2D

func _process(delta):
	if !Player:
		Player = Globals.player
	scale.x = Player.facing
	
	$Sprite.position.x = 8 if Player.moving else 0
	$Sprite.rotation_degrees = 16 if Player.moving else 0
	
