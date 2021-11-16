extends Node2D

var selection = 0

export var selection_arrow_path: NodePath
onready var selection_arrow = get_node(selection_arrow_path)

export var root_path: NodePath
onready var root = get_node(root_path)

export var pause_path: NodePath
onready var pause_sfx = get_node(pause_path)

export var select_path: NodePath
onready var select_sfx = get_node(select_path)

export var change_path: NodePath
onready var change_sfx = get_node(change_path)

var funny_frame = false

var time = 0.0

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		selection = 0
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			pause_sfx.play()
			funny_frame = true
		else:
			select_sfx.play()
			
	if get_tree().paused:
		
		
		
		$select.rect_rotation = -8 + 8*sin(time*0.01)
		time += 1
		
		if Input.is_action_just_pressed("down") || Input.is_action_just_pressed("ui_down"):
			change_sfx.play()
			selection += 1
		if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("ui_up"):
			change_sfx.play()
			selection -= 1
		selection = (selection + 3) % 3
		
		selection_arrow.rect_position.y = 150 + 72*selection
		
		if Input.is_action_just_pressed("shoot") || Input.is_action_just_pressed("ui_accept"):
			select_sfx.play()
			match selection:
				0:
					get_tree().paused = false
					visible = false
				1:
					get_tree().paused = false
					Globals.Bullets.clear_bullets_from_memory()
					#root.reset_bullets()
					root.reset = true
				2:
					Globals.Bullets.clear_bullets_from_memory()
					Globals.clear_objects()
					#root.reset_bullets()
					get_tree().paused = false
					get_tree().change_scene("res://titlescreen.tscn")
		
		if !funny_frame && (Input.is_action_just_pressed("bomb") || Input.is_action_just_pressed("ui_cancel")):
			select_sfx.play()
			get_tree().paused = false
			visible = false
			
		if !funny_frame && Input.is_action_just_pressed("reset"):
			select_sfx.play()
			Globals.Bullets.clear_bullets_from_memory()
			#root.reset_bullets()
			get_tree().paused = false
			root.reset = true
			
		if !funny_frame && Input.is_action_just_pressed("quit"):
			select_sfx.play()
			Globals.Bullets.clear_bullets_from_memory()
			Globals.clear_objects()
			get_tree().paused = false
			#root.reset_bullets()
			get_tree().change_scene("res://titlescreen.tscn")

		funny_frame = false
