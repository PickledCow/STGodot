extends ViewportContainer


func _ready():
	rect_scale = Vector2(1.0, 1.0) / Globals.TD_SCALE
	$Viewport.size = Vector2(1064.0, 1064.0) * Globals.TD_SCALE
	#if Globals.BG_TYPE != 0:
	#	queue_free()
