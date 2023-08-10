extends StaticBody2D

@onready var timer = $Timer
@onready var rock = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var level = Global.rock

var region_list = [
	[66, 49, 12, 12],
	[82, 48, 12, 13],
	[98, 48, 12, 13],
	[82, 64, 12, 13],
	[98, 64, 12, 13],
	[66, 27, 12, 18],
]
# Called when the node enters the scene tree for the first time.
func _ready():
	match level:
		1: timer.wait_time = 5
		2: timer.wait_time = 15
		3: timer.wait_time = 30
	
	# random art for rocks
	var rand_region = region_list.pick_random()
	rock.region_rect = Rect2(rand_region[0], rand_region[1], rand_region[2], rand_region[3])

func _on_timer_timeout():
	anim.call_deferred('play', 'disappear')
