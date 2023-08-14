extends Node2D

var health = 0

@onready var anim = $AnimationPlayer
@onready var level = Global.fire
@onready var timer = $Timer

func _ready():
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
