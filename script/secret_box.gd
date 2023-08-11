extends ENEMIES

@export var power = 0

const types = ['hover', 'rand', 'strong']
const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
#const FIRE = preload('res://skills/fire.tscn')
#const ROCK = preload('res://skills/rock.tscn')
#const TANK = preload("res://skills/tank.tscn")

var running: bool = false
var give_gift: bool = false
# random type of chalenge
var type = types.pick_random()
var tween: Tween
var rand_letter = generate_word(characters, 1)

@onready var label = $key/Label
@onready var anim = $AnimationPlayer
@onready var timer = $deadTimer
@onready var bar = $deadBar

func _ready():
# make random colar for key:
	anim.play('idle')
	match type:
		'hover': 
			# random timer wait_time
			timer.wait_time = randf_range(3.0, 4.0)
			label.text = rand_letter
		'rand': 
			# random power of enemy from 4 to 5:
			power =  randi_range(4, 5)
			# random text for character:
			label.text = rand_letter
		'strong': 
			# random power of enemy from 10 to 15:
			power =  randi_range(10, 15)
			# random text for character:
			label.text = rand_letter + ' x ' + str(power)
# make deadBar unvisible
	bar.visible = false

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		match type:
			'hover': 
				if event.is_pressed() && OS.get_keycode_string(event.keycode) == rand_letter:
					if !running:
						timer.start()
						bar.visible = true
						running = true
						if tween:
							tween.kill() # Abort the previous animation.
						tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
						tween.tween_property(bar, 'value', 100, timer.wait_time - 0.1)
				if event.is_released() && OS.get_keycode_string(event.keycode) == rand_letter:
		#			reset timer
					if running:
						timer.stop()
						timer.set_wait_time(1.0)
						running = false
						if tween:
							tween.kill() # Abort the previous animation.
						tween = create_tween()
						tween.tween_property(bar, 'value', 0, 0.5)
						await tween.finished
						bar.visible = false
			'rand': 
				if event.is_released() && OS.get_keycode_string(event.keycode) == rand_letter:
					power -= 1
					if power <= 0:
						if !give_gift:
#							rand_gift()
							pass
						dead()
					else :
						anim.play("change_letter")
						# re-random letter after every time;
						rand_letter = generate_word(characters, 1)
						label.text = rand_letter
						await anim.animation_finished
						anim.play('idle')
			'strong': 
				if event.is_released() && OS.get_keycode_string(event.keycode) == rand_letter:
					power -= 1
					label.text = rand_letter + ' x ' + str(power)
					if power <= 0:
						if !give_gift:
#							rand_gift()
							pass
						dead()


func dead(): #random gift 
	anim.play("disappear")
	speed = 0

#func rand_gift():
#	give_gift = true
#	var rand_gift = []
#	if (Global.rock > 0):
#		rand_gift.append(0)
#	if (Global.fire > 0):
#		rand_gift.append(1)
#	if (Global.tank > 0):
#		rand_gift.append(4)
#	if (Global.stop > 0):
#		rand_gift.append(3)
#	if (Global.bomb > 0):
#		rand_gift.append(2)
#	if (Global.heal > 0):
#		rand_gift.append(5)
#	match rand_gift.pick_random():
#		0: 
#			# appear rock gift
#			var rock = ROCK.instantiate()
#			rock.global_position = self.position
#			rock.z_index = self.z_index
#			get_parent().call_deferred('add_child', rock)
#			await anim.animation_finished
#			queue_free()
#		1: 
#			# appear fire gift
#			var fire = FIRE.instantiate()
#			fire.global_position = self.position
#			fire.z_index = self.z_index
#			get_parent().call_deferred('add_child', fire)
#			await anim.animation_finished
#			queue_free()
#		2: 
#			# destroy all enemies scene random
#			var percent = 0.01
#			match Global.bomb: 
#				2: percent = 0.05
#				3: percent = 0.1
#
#			if (randf() < percent):
#				var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
#				if (len(enemies_appear) > 0):
#					for enemy in enemies_appear:
#						enemy.dead()
#				await anim.animation_finished
#				queue_free()
#		3: 
#			# pause scene
#			var stop_time = 2.0
#			match Global.stop: 
#				2: stop_time = 5.0
#				3: stop_time = 10.0
#
#			var prev_speeds = []
#			var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
#			# stop spawm/process enemies
#			get_parent().spawn_timer.stop()
#			get_parent().progress_timer.stop()
#			# stop all enemies exist
#			if (len(enemies_appear) > 0):
#				for enemy in enemies_appear:
#					prev_speeds.append(enemy.speed)
#					enemy.speed = 0
#			# timer stop for ...
#			await get_parent().get_tree().create_timer(stop_time).timeout
#			# respawn enemies and contimue game
#			get_parent().spawn_timer.start()
#			get_parent().progress_timer.start()
#			# reset speed for all enemies
#			if (len(enemies_appear) > 0):
#				for i in range(len(enemies_appear)):
#					enemies_appear[i].speed = prev_speeds[i]
#			await anim.animation_finished
#			queue_free()
#		4: 
#			# appear tank gift
#			var tank = TANK.instantiate()
#			tank.global_position = self.position
#			tank.z_index = self.z_index
#			get_parent().call_deferred('add_child', tank)
#			await anim.animation_finished
#			queue_free()
#		5: 
#			print('heal roi ne!!!')

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_dead_timer_timeout():
	running = false
	if !give_gift:
#		rand_gift()
		pass
	dead()
