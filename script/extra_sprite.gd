extends Node2D

const colors = ['idle', 'idle_2']

@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# make random colar for key:
	anim.play(colors.pick_random())

func change_letter():
	anim.play("change_letter")
	await anim.animation_finished
	anim.play(colors.pick_random())
