extends Object

var graze = 0
#var score = 0
var value = 1000

var player = null
var pid = 0
var root = null
var Bullets = null


var DIFFICULTY = 3

enum ATTACK_TYPE {NON, SPELL, TO, FINAL, FINAL2}

var TDBG: PackedScene
var unusual: Node2D
var unusual_selection = 0

var BG_TYPE = 0 #0: 3D, 1: 2D
export var TD_SCALE = 0.7

var game_started = false

func clear_objects():
	player = null
	root = null
	Bullets = null
