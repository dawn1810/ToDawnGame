extends Node2D

signal game_over

const damage_sound1 = preload("res://audio/damage_audio/damge_sudio01.mp3")
const damage_sound2 = preload("res://audio/damage_audio/damge_sudio02.mp3")


@export var max_health = 100

@onready var health = max_health
@onready var anim = $AnimationPlayer
@onready var audio = $AudioStreamPlayer2D
@onready var health_bar = get_parent().get_node('Ontop/HBoxContainer/heardBar')

func damnge(amount):
	# break audio
	match randi_range(0, 1):
		0: audio.stream = damage_sound1
		1: audio.stream = damage_sound2
	
	audio.play()
	
	get_parent().camera.shake(500, 0.4, 1000)
	health -= amount
	health_bar._damage(amount/10)
	if health <= 0:
		# explose
		anim.call_deferred('play', 'explose')
		# clear all enemies on stage
		var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
		if (len(enemies_appear) > 0):
			for enemy in enemies_appear:
				enemy.dead()
		# game_over
		emit_signal('game_over')

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
