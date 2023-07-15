extends CharacterBody2D
class_name  ENEMIES


@export var speed = 300.0
@export var attack_amount = 0


func _physics_process(delta):
	velocity = Vector2.LEFT * speed
	move_and_slide()

func dead():
# add dead animation here
	print('dead')
	queue_free()
