extends CanvasLayer

onready var root = get_node("../axis/root")
onready var Bullets = Globals.Bullets
onready var player = Globals.player
var t = 0

onready var power_main = get_node("powers/powerdisplaymain")
onready var power_sub = get_node("powers/powerdisplaysub")

onready var graze = get_node("grazedisplay")
onready var graze_commas = get_node("markings4")

onready var value = get_node("valuedisplay")
onready var value_commas = get_node("markings3")

onready var score = get_node("scoredisplay")
onready var score_commas = get_node("markings2")

const unfinished_lives = Color('#1a000d')
const finished_lives = Color('#bf0060')
onready var lives = get_node("lives")
const unfinished_bombs = Color('#001a00')
const finished_bombs = Color('#00ab00')
onready var bombs = get_node("bombs")

onready var difficulty_display = get_node("difficultytext")


func _ready():
	$AnimationPlayer.play("load")
	for lives_icon in lives.get_children():
		lives_icon.max_value = player.life_requirement
		
	for bomb_icon in bombs.get_children():
		bomb_icon.max_value = player.bomb_requirement
	
	var difficulty_font = difficulty_display.get_font("normal_font")
	match Globals.DIFFICULTY:
		0:
			difficulty_display.bbcode_text = "[center]EASY"
			difficulty_font.outline_color = Color("#00902c")
		1:
			difficulty_display.bbcode_text = "[center]NORMAL"
			difficulty_font.outline_color = Color("#0054b2")
		2:
			difficulty_display.bbcode_text = "[center]HARD"
			difficulty_font.outline_color = Color("#0009c5")
		3:
			difficulty_display.bbcode_text = "[center]LUNATIC"
			difficulty_font.outline_color = Color("#9700a0")
		4:
			difficulty_display.bbcode_text = "[center]EXTRA"
			difficulty_font.outline_color = Color("#bd0000")
		5:
			difficulty_display.bbcode_text = "[center]OVERDRIVE"
			difficulty_font.outline_color = Color("#bd0000")

func _process(delta):
	t += delta
	if t > 1:
		t -= 1
		$fps.text = 'FPS: ' + str(Engine.get_frames_per_second())
	var bullet_count = len(Bullets.active_bullets) + len(Bullets.loose_lasers) + len(Bullets.straight_lasers)
	for l in Bullets.curve_lasers:
		bullet_count += len(l.bullets)
	$bulletcount.text = 'Bullets: ' + str(bullet_count)	
	
	score.bbcode_text = '[right]' + str(root.score).replace('0', 'O') + ' '
	score_commas.bbcode_text = '[right]'
# warning-ignore:integer_division
	var score_comma_count = (len(str(root.score))-1) / 3
	for i in score_comma_count:
		score_commas.bbcode_text += ','
		if i != score_comma_count-1:
			score_commas.bbcode_text += '     '
	
	
	power_main.bbcode_text = '[right]' + str(player.power).replace('0', 'O')
	var power_decimal = str(player.power_decimal).replace('0', 'O')
	if len(power_decimal) == 1:
		power_decimal = 'O' + power_decimal
	power_sub.text = ' .' + power_decimal
	
	graze.bbcode_text = '[right]' + str(root.graze).replace('0', 'O') + ' '
	graze_commas.bbcode_text = '[right]'
# warning-ignore:integer_division
	var graze_comma_count = (len(str(root.graze))-1) / 3
	for i in graze_comma_count:
		graze_commas.bbcode_text += ','
		if i != graze_comma_count-1:
			graze_commas.bbcode_text += '    '
	
	value.bbcode_text = '[right]' + str(root.piv).replace('0', 'O') + ' '
	value_commas.bbcode_text = '[right]'
# warning-ignore:integer_division
	var value_comma_count = (len(str(root.piv))-1) / 3
	for i in value_comma_count:
		value_commas.bbcode_text += ','
		if i != value_comma_count-1:
			value_commas.bbcode_text += '    '
	
	
	var lives_icons = lives.get_children()
	for i in len(lives_icons):
		lives_icons[i].value = lives_icons[i].max_value if i < player.lives else 0
		lives_icons[i].get_children()[0].modulate = finished_lives if i < player.lives else unfinished_lives
	
	if player.lives < len(lives_icons):
		lives_icons[player.lives].value = player.life_fragments
	$livesover.text = '+' + str(player.lives - len(lives_icons)) if player.lives > len(lives_icons) else ''
		
	
	var bombs_icon = bombs.get_children()
	for i in len(bombs_icon):
		bombs_icon[i].value = bombs_icon[i].max_value if i < player.bombs else 0
		bombs_icon[i].get_children()[0].modulate = finished_bombs if i < player.bombs else unfinished_bombs
		
	if player.bombs < len(bombs_icon):
		bombs_icon[player.bombs].value = player.bomb_fragments
		
	
	
func _delete_residue_ui():
	pass
	
