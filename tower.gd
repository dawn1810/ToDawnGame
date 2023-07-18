extends Node2D

@export var max_health = 100

@onready var health = max_health
@onready var anim = $AnimationPlayer

func damnge(amount):
	health -= amount
	print(health)
#	if health <= 0:
#		print('game over')
#	elif health <= 20:
#		print('dengerous')
#	elif health <= 50:
#		print('u should concentate now')
#	elif health <= 80:
#		print('we lose some health now')

func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
# make enermis disappear
		body.dead()
		if !body.is_in_group('box'):
# play animation attacked
			anim.play("attacked")
# lose some health
			damnge(body.attack_amount)
		else:
# chest do not queue free after dead function
			await body.anim.animation_finished
			body.queue_free()
