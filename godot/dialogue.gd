extends Node2D

export(String, FILE, "*.txt") var dialogue_path

export var root_path: NodePath
onready var root = get_node(root_path)

# char, skippable, decay, message
var dialogue = []

var speaker = 1
var skippable = true
var dialogue_line = 0
var dialogue_time = 0

onready var text_label = get_node("Panel/RichTextLabel")
onready var text_bg = get_node("Panel")

func load_dialogue():
	dialogue.clear()
	var f = File.new()
	f.open(dialogue_path, File.READ)
	while !f.eof_reached():
		var line = f.get_line()
		var dialogue_line = Array(line.split('|'))
		for i in 3:
			dialogue_line[i] = int(dialogue_line[i])
		dialogue.append(dialogue_line)

func _ready():
	load_dialogue()

func _process(_delta):
	if dialogue_time == 0:
		if dialogue_line < len(dialogue):
			var d = dialogue[dialogue_line]
			dialogue_line += 1
			if speaker == 1 && d[0] == 0:
				$AnimationPlayer.play("player")
				text_bg.rect_scale.x = 1
				text_label.rect_scale.x = 1
			elif speaker == 0 && d[0] == 1:
				$AnimationPlayer.play_backwards("player")
				text_bg.rect_scale.x = -1
				text_label.rect_scale.x = -1
			speaker = d[0]
			skippable = d[1] == 1
			dialogue_time = d[2]
			
			var text_size = text_label.get_font("normal_font").get_string_size(d[3])
			if speaker == 0:
				text_label.bbcode_text = d[3] #"[/right]"+d[3]
				text_label.margin_left = 24
				text_label.margin_right = 24+text_size.x
				text_bg.margin_left = 200
				text_bg.margin_right = 200+text_size.x+48
				
				text_label.margin_top = 24
				text_label.margin_bottom = 24+text_size.y
				text_bg.margin_top = 666
				text_bg.margin_bottom = 666+text_size.y+48
			else:
				text_label.bbcode_text = "[right]"+d[3]
				text_label.margin_left = text_size.x-576+48
				text_label.margin_right = 2*text_size.x-576+48
				text_bg.margin_left = 200
				text_bg.margin_right = 200+text_size.x+48
				
				text_label.margin_top = 24
				text_label.margin_bottom = 24+text_size.y
				text_bg.margin_top = 666
				text_bg.margin_bottom = 666+text_size.y+48
				
		else:
			$AnimationPlayer.play("exit")
			root.dialogue = false
			skippable = false
			
	
	dialogue_time -= 1
	
	if Input.is_action_just_pressed("shoot") && skippable:
		dialogue_time = 0
