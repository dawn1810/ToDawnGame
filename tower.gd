extends Node2D

signal game_over

@export var max_health = 100

@onready var health = max_health
@onready var anim = $AnimationPlayer

func damnge(amount):
	health -= amount
	print(health)
	if health <= 0:
		emit_signal('game_over')
#	elif health <= 20:
#		print('dengerous')
#	elif health <= 50:
#		print('u should concentate now')
#	elif health <= 80:
#		print('we lose some health now')

func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		if body.get_parent().name == 'RandBoss':
			body.get_parent().dead()
			# play animation attacked
			anim.play("attacked")
			# game over
			damnge(100)
		else:
			# make enermis disappear
			body.dead()
		# play animation attacked
		anim.play("attacked")
		# lose some health
		damnge(body.attack_amount)
	if body.is_in_group('boss'):
		body.dead()
		# play animation attacked
		anim.play("attacked")
		# game over
		damnge(100)
