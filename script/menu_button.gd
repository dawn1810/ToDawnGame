extends TextureButton

const click_sound1 = preload("res://audio/click_audio/mixkit-camera-shutter-click-1133.wav")
const click_sound2 = preload("res://audio/click_audio/mixkit-stapling-paper-2995.wav")

@export var clr = 'focus_2' 
@export var txt = 'Play'

@onready var anim = $AnimationPlayer
@onready var text = $Label
@onready var sprite = $Sprite2D
@onready var audio = $AudioStreamPlayer2D

func _ready():
	_reset_rect()
	text.text = txt

func _reset_rect():
	match clr:
		'focus':
			anim.play("reset")
		'focus_2':
			anim.play("reset_2")
		'small_focus':
			anim.play("small_reset")
		'small_focus_2':
			anim.play("small_reset_2")

func _play_click_sound():
	# random click sound:
	match randi_range(0, 1):
		0: audio.stream = click_sound1
		1: audio.stream = click_sound2
	audio.play()

func _on_focus_entered():
	anim.play(clr)

func _on_focus_exited():
	_reset_rect()

func _on_mouse_entered():
	anim.play(clr)

func _on_mouse_exited():
	_reset_rect()

func _on_pressed():
	_play_click_sound()
