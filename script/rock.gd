extends StaticBody2D

const rock_sound = preload("res://audio/rock.mp3")

@onready var timer = $Timer
@onready var rock = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var level = Global.rock
@onready var audio = $AudioStreamPlayer2D

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
	audio.stream = rock_sound
	audio.play()
	
	match level:
		1: timer.wait_time = 5
		2: timer.wait_time = 10
		3: timer.wait_time = 20
	
	
	# random art for rocks
	var rand_region = region_list.pick_random()
	rock.region_rect = Rect2(rand_region[0], rand_region[1], rand_region[2], rand_region[3])

func _on_timer_timeout():
	anim.call_deferred('play', 'disappear')

func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		if body.get_parent().name == 'RandBoss':
			anim.call_deferred('play', 'disappear')
		else:
			print('start timer')
			timer.start()
	if body.is_in_group('boss'):
		anim.call_deferred('play', 'disappear')
