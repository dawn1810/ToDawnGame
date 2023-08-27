extends Node2D

const  fire_sound1 = preload("res://audio/burn_audio/mixkit-big-fire-spell-burning-1332 (mp3cut.net).mp3")
const  fire_sound2 = preload("res://audio/burn_audio/mixkit-fire-swoosh-burning-1328 (mp3cut.net).mp3")


var health = 0

@onready var anim = $AnimationPlayer
@onready var level = Global.fire
@onready var timer = $Timer
@onready var audio = $AudioStreamPlayer2D

func _ready():
	# random burn sound:
	match randi_range(0, 1):
		0: audio.stream = fire_sound1
		1: audio.stream = fire_sound2
	audio.play()
	
	match level:
		1: 
			timer.wait_time = 10
			health = 1
		2: 
			timer.wait_time = 20
			health = 2
		3: 
			timer.wait_time = 30
			health = 3
	# random color for fire:
	var values = [0, 0.5, 1]
	var r = 0
	var g = 0
	var b = 0
	while r == 0 and g == 0 and b == 0:
		r = values.pick_random()
		g = values.pick_random()
		b = values.pick_random()
	self.modulate = Color(r, g, b)

func _on_area_2d_body_entered(body):
	health -= 1
	if body.is_in_group('enemy'):
		# make enemies disappear
		body.dead()
	
	# dead by lose all health
	if health == 0:
		anim.call_deferred('play', 'disappear')

func _on_timer_timeout():
	anim.call_deferred('play', 'disappear')
