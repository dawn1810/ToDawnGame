extends ENEMIES

@export var power = 0

const types = ['hover', 'rand', 'strong']
const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const FIRE = preload('res://skills/fire.tscn')
const ROCK = preload('res://skills/rock.tscn')
const BASIC = preload('res://enemies/basic_enemy.tscn')

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
							rand_gift()
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
							rand_gift()
						dead()


func dead(): #random gift 
	anim.play("disappear")
	speed = 0

func rand_gift():
	give_gift = true
	var rand_gift = randi_range(0, 5)
	match rand_gift:
		0: 
			# appear rock gift
			var rock = ROCK.instantiate()
			rock.global_position = self.position
			rock.z_index = self.z_index
			get_parent().call_deferred('add_child', rock)
			await anim.animation_finished
			queue_free()
		1: 
			# appear fire gift
			var fire = FIRE.instantiate()
			fire.global_position = self.position
			fire.z_index = self.z_index
			get_parent().call_deferred('add_child', fire)
			await anim.animation_finished
			queue_free()
		2: 
			# destroy all enemies scene
			var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
			if (len(enemies_appear) > 0):
				for enemy in enemies_appear:
					enemy.dead()
			await anim.animation_finished
			queue_free()
		3: 
			# pause scene
			var prev_speeds = []
			var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
			if (len(enemies_appear) > 0):
				for enemy in enemies_appear:
					prev_speeds.append(enemy.speed)
					enemy.speed = 0
			await get_parent().get_tree().create_timer(5.0).timeout
			if (len(enemies_appear) > 0):
				for i in range(len(enemies_appear)):
					enemies_appear[i].speed = prev_speeds[i]
			await anim.animation_finished
			queue_free()
		4: 
			# enemy gift
			var basic = BASIC.instantiate()
			basic.global_position = self.position
			basic.z_index = self.z_index
			get_parent().call_deferred('add_child', basic)
			await anim.animation_finished
			queue_free()
		5: 
			# up enemies speed 50:
			var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
			if (len(enemies_appear) > 0):
				for enemy in enemies_appear:
					enemy.speed += 80
			await anim.animation_finished
			queue_free()

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_dead_timer_timeout():
	running = false
	if !give_gift:
		rand_gift()
	dead()
