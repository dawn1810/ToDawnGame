extends Node2D

const colors = ['idle', 'idle_2']

var rand_color = colors.pick_random()

@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# make random colar for key:
	anim.play(rand_color)

func change_letter():
	anim.play("change_letter")
	await anim.animation_finished
	anim.play(rand_color)
