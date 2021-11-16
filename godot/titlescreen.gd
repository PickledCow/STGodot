extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var menu = 0

var selection = 0
var selection_difficulty = 0
var selection_character = 0
var selection_settings = 0
var selection_cosmetics = 0
var selection_cosmetic_character = 0

var volume = 1.0

var settings_selection_positions = [140, 290, 475, 602, 758, 908]

var effect_names = ["None", "Haunted Flames", "Frostburnt Flames", "Blazing Flames", "Cosmic Flames", "Torrential Precipitation", "Storm Days", "Eye of the Storm", "Icicle Bowl", "100 Dollaridoos"]

var change_scene = false

export var selection_icon_path: NodePath
onready var selection_icon = get_node(selection_icon_path)

export var selection_icon_difficulty_path: NodePath
onready var selection_icon_difficulty = get_node(selection_icon_difficulty_path)

export var selection_icon_character_path: NodePath
onready var selection_icon_character = get_node(selection_icon_character_path)

export var selection_icon_settings_path: NodePath
onready var selection_icon_settings = get_node(selection_icon_settings_path)

var fs = true

var anim_finished = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("main")
	selection_cosmetics = Globals.unusual_selection
	if !Globals.game_started:
		Globals.game_started = true
		OS.window_fullscreen = true
		Engine.target_fps = 60
		

func _process(delta):
	if change_scene:
		if Globals.BG_TYPE == 0:
			Globals.TDBG = load("res://bg/rain.tscn")
		else:
			Globals.TDBG = null
		if selection_cosmetics:
			var effect = get_node("effects/sprites/effects").get_child(selection_cosmetics - 1)
			get_node("effects/sprites/effects").remove_child(effect)
			Globals.unusual = effect
			Globals.unusual_selection = selection_cosmetics
		get_tree().change_scene("res://game.tscn")
		change_scene = false
	if anim_finished:
		match menu:
			0:
				if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
					selection += 1
				if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
					selection -= 1
				
				selection = (selection + 4) % 4
				
				selection_icon.rect_position.y = 610 + selection*96
				
				if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept"):
					match selection:
						0:
							menu = 1
							$main.visible = false
							$difficulty.visible = true
						1:
							menu = 3
							$main.visible = false
							$effects.visible = true
							get_node("effects/sprites/effects").visible = true
						2:
							menu = 4
							$main.visible = false
							$settings.visible = true
						3:
							get_tree().quit()
			1:
				 
				if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
					selection_difficulty += 1
				if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
					selection_difficulty -= 1
				
				selection_difficulty = (selection_difficulty + 4) % 4
				
				selection_icon_difficulty.rect_position.y = 200 + selection_difficulty*200
				
				if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept"):
					Globals.DIFFICULTY = selection_difficulty
					menu = 2
					$difficulty.visible = false
					$character.visible = true
					
				if Input.is_action_just_pressed("bomb") || Input.is_action_just_pressed("ui_cancel"):
					menu = 0
					$main.visible = true
					$difficulty.visible = false
			2:
				 
				if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
					selection_character += 1
				if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
					selection_character -= 1
				
				selection_character = (selection_character + 2) % 2
				
				selection_icon_character.rect_position.y = 350 + selection_character*200
				
				if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept"):
					Globals.pid = selection_character
					$loading.visible = true
					change_scene = true
					
				if Input.is_action_just_pressed("bomb") || Input.is_action_just_pressed("ui_cancel"):
					menu = 1
					$difficulty.visible = true
					$character.visible = false
					6
			3:
				 
				if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
					selection_cosmetics += 1
				if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
					selection_cosmetics -= 1
				
				selection_cosmetics = (selection_cosmetics + len(effect_names)) % len(effect_names)
				
				for i in range(-2, 3):
					get_node("effects/" + str(i)).text = effect_names[(selection_cosmetics + len(effect_names) + i) % len(effect_names)]
				
				for i in len(effect_names)-1:
					get_node("effects/sprites/effects").get_child(i).visible = selection_cosmetics != 0 && i == selection_cosmetics - 1
				
				if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("ui_left"):
					selection_cosmetic_character -= 1
				if Input.is_action_just_pressed("right") || Input.is_action_just_pressed("ui_right"):
					selection_cosmetic_character += 1
				
				selection_cosmetic_character = (selection_cosmetic_character + 2) % 2
				
				get_node("effects/sprites/reimu").visible = selection_cosmetic_character == 0
				get_node("effects/sprites/marisa").visible = selection_cosmetic_character == 1
			
				if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("bomb") || Input.is_action_just_pressed("ui_cancel"):
					menu = 0
					$main.visible = true
					$effects.visible = false
					get_node("effects/sprites/reimu").visible = false
					get_node("effects/sprites/marisa").visible = false
					get_node("effects/sprites/effects").visible = false
					
			4:
				 
				if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
					selection_settings += 1
				if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
					selection_settings -= 1
				
				selection_settings = (selection_settings + 6) % 6
				
				selection_icon_settings.rect_position.y = settings_selection_positions[selection_settings]
				
				if Globals.BG_TYPE == 0:
					get_node("settings/3Dbgs").modulate = Color(1,1,1)
					get_node("settings/2Dbgs").modulate = Color(0.5,0.5,0.5)
				else:
					get_node("settings/3Dbgs").modulate = Color(0.5,0.5,0.5)
					get_node("settings/2Dbgs").modulate = Color(1,1,1)
				
				get_node("settings/3dscalenum").bbcode_text = "[center]"+str(Globals.TD_SCALE*100) + "%"
				
				get_node("settings/volumenum").bbcode_text = "[center]"+str(volume*100) + "%"
				
				if selection_settings == 2:
					if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("ui_left"):
						Globals.TD_SCALE -= 0.1
					if Input.is_action_just_pressed("right") || Input.is_action_just_pressed("ui_right"):
						Globals.TD_SCALE += 0.1
				Globals.TD_SCALE = clamp(Globals.TD_SCALE, 0.1, 1.5)
				get_node("settings/3dscalebar").value = Globals.TD_SCALE
				
				if selection_settings == 3:
					if Input.is_action_just_pressed("left") || Input.is_action_just_pressed("ui_left"):
						volume -= 0.1
					if Input.is_action_just_pressed("right") || Input.is_action_just_pressed("ui_right"):
						volume += 0.1
				AudioServer.set_bus_volume_db(0, linear2db(float(volume)))
				volume = clamp(volume, 0.1, 1.0)
				get_node("settings/volumebar").value = volume
				
				
				if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept"):
					match selection_settings:
						0:
							Globals.BG_TYPE = 1
						1:
							Globals.BG_TYPE = 0
						4:
							fs = false
							OS.window_fullscreen = false
						5:
							fs = true
							OS.window_fullscreen = true
							
				if !fs:
					get_node("settings/windowed").modulate = Color(1,1,1)
					get_node("settings/fs").modulate = Color(0.5,0.5,0.5)
				else:
					get_node("settings/windowed").modulate = Color(0.5,0.5,0.5)
					get_node("settings/fs").modulate = Color(1,1,1)
				
				if Input.is_action_just_pressed("bomb") || Input.is_action_just_pressed("ui_cancel"):
					menu = 0
					$main.visible = true
					$settings.visible = false
					
	
func anim_done(anim_name):
	anim_finished = true
