extends CharacterBody2D
class_name  ENEMIES


@export var speed = 300.0
@export var attack_amount = 0
@export var key_text : String
@export var kill : bool = true

var move: bool = true

func _physics_process(delta):
	if move:
		velocity = Vector2.LEFT * speed
		move_and_slide()

func dead():
# add dead animation here
	print('dead')

func _on_buff_speed_body_entered(body):
	if body.is_in_group('enemy') && body != self && body.speed < self.speed:
		body.speed = self.speed
