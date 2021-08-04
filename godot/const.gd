extends Object

const OFFSET = Vector2(64, 32)


const FIELD_SIZE = Vector2(1000, 1000)
const CLEAR_RECT = Rect2(Vector2(1,1) * -192.0, FIELD_SIZE + Vector2(1,1) * 192.0*2.0)

enum ITEM {POWER_LARGE, LIFE_FRAGMENT, LIFE, BOMB_FRAGMENT, BOMB, FULL, POWER, POINT, PIV, LENGTH}

enum BULLET_KIND { BULLET, LOOSE_LASER, STRAIGHT_LASER, CURVE_LASER}

enum BULLET_TYPE {	LEGACY_LASER, ARROWHEAD, BALL_OUTLINE, BALL, RICE, KUNAI, ICE, AMULET, BULLET, BACTERIA, STAR, DROPLET, # 0 - 11
					POPCORN, RICE_SMALL, COIN, SNOWBALL, # 12 - 15
					STAR_LARGE, MENTOS, BUTTERFLY, KNIFE, JELLYBEAN, DONTUSE, #16 - 21 
					BUBBLE, #22
					HEART, ARROW, REST, ICE_LARGE, FIREBALL, # 23 - 27
					DIVINE_SPIRIT, # 28
					LASER, # 29
					LIGHTNING, # 30
					GEAR, # 31
					SAW, # 32
					GEAR_SMALL, # 33
					SAW_SMALL, # 34
					MONEY, # 35
					NOTE, # 36
}


const TRANSFORM_COND = {
	TIME = 0,
	GRAZE = -2,
	BOUNCE = -3,
	WARP = -4
}


const BULLET_SIZES = [
					3, 1.5, 3, 3, 2.5, 2.5, 3, 2.8, 2.5, 2.5, 3, 2,
					2, 1.5, 3, 2,
					6, 8, 4, 3, 5, 6,
					14,
					10, 4, 2, 8, 4,
					14,
					5,
					5,
					30,
					30,
					10,
					10,
					3,
					3,
]

# x: size per 1 width, y: clearance front, z: clearance back
# Vector3(
const LASER_SIZES = [
					Vector3(0.15, 0.05, 0.05), Vector3(0.1875, 0.6, 0.2), Vector3(0.15, 0.25, 0.25), Vector3(0.15, 0.25, 0.25), Vector3(0.25, 0.125, 0.125), Vector3(0.25, 0.125, 0.5), Vector3(0.25, 0.125, 0.125), Vector3(0.5, 0.125, 0.125), Vector3(0.25, 0.2, 0.125), Vector3(0.1, 0.3, 0.3), Vector3(0.25, 0.125, 0.125), Vector3(0.125, 0.25, 0.25),
					Vector3(0.25, 0.2, 0.2), Vector3(0.25, 0.2, 0.2), Vector3(0.375, 0.3125, 0.3125), Vector3(0.25, 0.2, 0.2),
					Vector3(0.3, 0.4, 0.3125), Vector3(0.5, 0.3125, 0.3125), Vector3(0.16, 0.43, 0.3125), Vector3(0.1, 0.1, 0.4), Vector3(0.1875, 0.28, 0.28), Vector3(0.3125, 0.35, 0.35),
					Vector3(0.45, 0.28, 0.28),
					Vector3(0.25, 0.35, 0.3), Vector3(0.15, 0.1, 0.72), Vector3(0.1875, 0.43, 0.43), Vector3(0.125, 0.25, 0.25), Vector3(0.375, 0.28, 0.375),
					Vector3(0.3, 0.35, 0.35),
					Vector3(0.15, 0.05, 0.05), 
					Vector3(0.0625, 0.1, 0.1), 
					Vector3(0.0625, 0.1, 0.1), 
					Vector3(0.0625, 0.1, 0.1), 
					Vector3(0.0625, 0.1, 0.1), 
					Vector3(0.0625, 0.1, 0.1), 
					Vector3(0.03, 0.1, 0.1), 
					Vector3(0.15, 0.05, 0.05),
]

const NO_ROTATE_BULLETS = [BULLET_TYPE.BALL_OUTLINE, BULLET_TYPE.BALL, BULLET_TYPE.POPCORN, BULLET_TYPE.SNOWBALL, BULLET_TYPE.MENTOS, BULLET_TYPE.DIVINE_SPIRIT]

const SMALL_BULLETS = [BULLET_TYPE.LEGACY_LASER, BULLET_TYPE.ARROWHEAD, BULLET_TYPE.BALL_OUTLINE, BULLET_TYPE.BALL, BULLET_TYPE.RICE, BULLET_TYPE.KUNAI, BULLET_TYPE.ICE, BULLET_TYPE.AMULET, BULLET_TYPE.BULLET, BULLET_TYPE.BACTERIA, BULLET_TYPE.STAR, 
					BULLET_TYPE.POPCORN, BULLET_TYPE.RICE_SMALL, BULLET_TYPE.SNOWBALL,
					BULLET_TYPE.DROPLET
					]

const LARGE_BULLETS = [
					BULLET_TYPE.STAR_LARGE, BULLET_TYPE.MENTOS, BULLET_TYPE.BUTTERFLY, BULLET_TYPE.KNIFE, BULLET_TYPE.JELLYBEAN,
					BULLET_TYPE.BUBBLE, 
					BULLET_TYPE.HEART, BULLET_TYPE.ARROW, BULLET_TYPE.REST, BULLET_TYPE.FIREBALL
					]

enum COLOURS {GREY, RED_D, RED, PURPLE_D, PURPLE, BLUE_D, BLUE, CYAN_D, CYAN, TEAL_D, TEAL, GREEN, YELLOW_D, YELLOW, ORANGE, WHITE}
enum COLOURS_LARGE {GREY, RED, PURPLE, BLUE, CYAN, GREEN, YELLOW, ORANGE}
enum COLOURS_NOTE { RED, PURPLE, BLUE, YELLOW}
enum COLOURS_DIVINE_SPIRIT {GREY, RED, PURPLE, BLUE, CYAN, GREEN, YELLOW, WHITE, ORANGE, RED_D, PURPLE_D, BLUE_D, CYAN_D, GREEN_D, YELLOW_D, GREY_D}
enum COLOURS_SAW {NORMAL, BLOOD}
enum COLOURS_COIN {RED, PURPLE, BLUE, CYAN, GREEN, GOLD, SILVER, BRONZE}
const FIREBALL_OFFSETS = [Vector2(1,3), Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(0,2), Vector2(1,2), Vector2(0,3), Vector2(1,1)] # Spritesheet maker made a mess and I didn't bother fixing it lol
const COLOUR_VALUES = [Color('#bfbfbf'), Color('#ff1a1a'), Color('#ff1aff'), Color('#1a1aff'), Color('#1affff'), Color('#1aff1a'), Color('#ffff1a'), Color('#ff8c1a')]

const LASER_SPAWN_UV = Color(0.0, 416.0 / 2048.0, 64.0 / 1024.0, 64.0 / 2048.0)

func note2largecolour(x):
	match x:
		COLOURS_NOTE.RED:
			return COLOURS_LARGE.RED
		COLOURS_NOTE.PURPLE:
			return COLOURS_LARGE.PURPLE
		COLOURS_NOTE.BLUE:
			return COLOURS_LARGE.BLUE
		COLOURS_NOTE.YELLOW:
			return COLOURS_LARGE.YELLOW

func small2largecolour(x):
	if x < COLOURS.GREEN:
		return int((x+1)*0.5)
	elif x == COLOURS.GREEN:
		return COLOURS_LARGE.GREEN
	elif x < COLOURS.WHITE:
		#6, 7
		return int(x*0.5)
	else:
		return COLOURS_LARGE.GREY

func divine2largecolour(x):
	if x < COLOURS_DIVINE_SPIRIT.WHITE:
		return x
	elif x == COLOURS_DIVINE_SPIRIT.WHITE:
		return COLOURS_LARGE.GREY
	elif x == COLOURS_DIVINE_SPIRIT.ORANGE:
		return COLOURS_LARGE.ORANGE
	elif x < COLOURS_DIVINE_SPIRIT.GREY_D:
		return x - 8
	else:
		return COLOURS_LARGE.GREY

func coin2largecolour(x):
	if x < COLOURS_COIN.SILVER:
		return x + 1
	elif x == COLOURS_COIN.SILVER:
		return COLOURS_LARGE.GREEN
	else:
		return COLOURS_LARGE.ORANGE
