extends Node2D

@export var max_health = 100

@onready var health = max_health

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func damnge(amount):
	health -= amount
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
# lose some health
		damnge(body.attack_amount)
# make enermis disappear after 0.2 second
		body.dead()
