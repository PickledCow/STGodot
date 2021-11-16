extends Node2D

export var type = Globals.ATTACK_TYPE.NON
export var attack_name = ""
export var attack_time = 60 * 30

export var start_pos = Vector2(500, 300)
export var health = 7500
export var start_delay = 120

export var timeout = false
export var no_bg = false

export var scb = 1000000

export var bg_flag = 0

var t = 0
var a = 0
var a2 = 0
var lr = 1

var difficulty = 0
var root: Node2D
var Bullets: Node2D
var parent: Node2D

func _ready():
	difficulty = Globals.DIFFICULTY
	root = Globals.root
	Bullets = Globals.Bullets
	parent = get_parent()

func set_dest(dest, time):
	parent.set_dest(dest, time)
	
