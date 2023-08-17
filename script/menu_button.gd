extends TextureButton

@export var clr = 'focus_2' 
@export var txt = 'Play'

@onready var anim = $AnimationPlayer
@onready var text = $Label
@onready var sprite = $Sprite2D

func _ready():
	_reset_rect()
	text.text = txt

func _reset_rect():
	if clr == 'focus':
		anim.play("reset")
		sprite.region_rect = Rect2i(0, 16, 48, 16)
	else :
		anim.play("reset_2")
		sprite.region_rect = Rect2i(0, 0, 48, 16)


func _on_focus_entered():
	anim.play(clr)

func _on_focus_exited():
	_reset_rect()

func _on_mouse_entered():
	anim.play(clr)

func _on_mouse_exited():
	_reset_rect()
