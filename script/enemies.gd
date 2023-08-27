extends CharacterBody2D
class_name  ENEMIES

signal stop_time

const FIRE = preload('res://skills/fire.tscn')
const ROCK = preload('res://skills/rock.tscn')
const TANK = preload("res://skills/tank.tscn")

const enter_sound1 = preload("res://audio/click_audio/enter-button-mechanical-keyboard-14388 (mp3cut.net) (1).mp3")
const enter_sound2 = preload("res://audio/click_audio/enter-button-mechanical-keyboard-14388 (mp3cut.net) (2).mp3")
const enter_sound3 = preload("res://audio/click_audio/enter-button-mechanical-keyboard-14388 (mp3cut.net).mp3")
const enter_sound4 = preload("res://audio/click_audio/enter-button-mechanical-keyboard-14388 (mp3cut.net) (4).mp3")
const enter_sound5 = preload("res://audio/click_audio/enter-button-mechanical-keyboard-14388 (mp3cut.net) (5).mp3")

@export var speed = 300.0
@export var attack_amount = 0

var move: bool = true
var default_percent: float = 0.2 # 20%

@onready var health_bar = get_parent().get_node('Ontop/HBoxContainer/heardBar')
@onready var audio = $AudioStreamPlayer2D

func _physics_process(delta):
	if move:
		velocity = Vector2.LEFT * speed
		move_and_slide()

func play_audio():
	# random audio:
	match randi_range(0, 4):
		0: audio.stream = enter_sound1
		1: audio.stream = enter_sound2
		2: audio.stream = enter_sound3
		3: audio.stream = enter_sound4
		4: audio.stream = enter_sound5
	
	audio.play()

func dead():
# add dead animation here
	print('dead')

func rand_gift(): # current Animation2d of current type of enemies
	var rand_gift = []
	if (Global.rock > 0):
		rand_gift.append(0)
	if (Global.fire > 0):
		rand_gift.append(1)
	if (Global.tank > 0):
		rand_gift.append(4)
	if (Global.stop > 0):
		rand_gift.append(3)
	if (Global.bomb > 0):
		rand_gift.append(2)
	if (Global.heal > 0):
		rand_gift.append(5)
	
	if len(rand_gift) :
		match rand_gift.pick_random():
			0: 
				# appear rock gift
				if (randf() < default_percent): # percent this rock appear
					var rock = ROCK.instantiate()
					if self.is_in_group("word_enemy"):
						rock.global_position = self.position + Vector2((self.rand_word.length() - 1) * 65, 0)
					else:
						rock.global_position = self.position
					rock.z_index = self.z_index
					get_parent().call_deferred('add_child', rock)
			1: 
				# appear fire gift
				if (randf() <= default_percent): # percent this fire appear
					var fire = FIRE.instantiate()
					if self.is_in_group("word_enemy"):
						fire.global_position = self.position + Vector2((self.rand_word.length() - 1) * 65, 0)
					else:
						fire.global_position = self.position
					fire.z_index = self.z_index
					get_parent().call_deferred('add_child', fire)
			2: 
				# destroy all enemies scene random
				var percent = 0.05
				match Global.bomb: 
					2: percent = 0.1
					3: percent = 0.2
				
				if (randf() < percent):
					var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
					if (len(enemies_appear) > 0):
						for enemy in enemies_appear:
							enemy.dead()
			3: 
				# pause scene
				if (randf() < default_percent): # percent this stop appear
					emit_signal('stop_time')
			4: 
				# appear tank gift
				if (randf() < default_percent): # percent this tank appear
					var tank = TANK.instantiate()
					if self.is_in_group("word_enemy"):
						tank.global_position = self.position + Vector2((self.rand_word.length() - 1) * 65, 0)
					else:
						tank.global_position = self.position
					tank.z_index = self.z_index
					get_parent().call_deferred('add_child', tank)
			5: 
				if (randf() < default_percent): # percent this heal appear
					match Global.heal:
						1: health_bar._heal(1)
						2: health_bar._heal(2)
						3: health_bar._heal(3)

func _on_buff_speed_body_entered(body):
	if body.is_in_group('enemy') && body != self && body.speed < self.speed:
		body.speed = self.speed

