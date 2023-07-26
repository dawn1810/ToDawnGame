extends Node2D

var health = randi_range(3, 5)

@onready var anim = $AnimationPlayer

func _on_area_2d_body_entered(body):
	health -= 1
	if body.is_in_group('enemy'):
# make enermis disappear
		body.dead()
	
	if health <= 0:
		anim.call_deferred('play', 'disappear')

