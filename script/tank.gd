extends CharacterBody2D

const stop_sound = preload("res://audio/car_audio/stop_car.mp3")

var speed = 200

@onready var anim = $AnimationPlayer
@onready var level = Global.tank
@onready var audio = $AudioStreamPlayer2D

func _ready():
	audio.play()
	
	match level:
		1: speed = 200
		2: speed = 100
		3: speed = 50

func _physics_process(delta):
	velocity = Vector2.RIGHT * speed
	move_and_slide()

func dead():
	audio.stop()
	audio.stream = stop_sound
	audio.play()
#
	anim.call_deferred('play', 'explose')


func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		if body.get_parent().name == 'RandBoss':
			dead()
		else:
			body.dead()
	if body.is_in_group('boss'):
		dead()


func _on_visible_on_screen_enabler_2d_screen_exited():
	await audio.finished
	queue_free()
