extends ENEMIES

signal deaded

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2', 'idle_3', 'idle_4', 'idle_5', 'idle_6','idle_7', 'idle_8', 'idle_9']

var heal = 0.01
var is_hide: bool = false

@onready var label = $key/Label
@onready var anim = $AnimationPlayer
@onready var control_anim = $CanvasLayer/Control/AnimationPlayer
@onready var appear = $appearTimer
@onready var disappear = $disappearTimer
@onready var sprite = $Sprite2D
@onready var bar = $CanvasLayer/Control/ProgressBar

func _ready():
	bar.value = 0
	# random text for character:
	label.text = generate_word(characters, 1)
	# make random colar for key:
	anim.play(colors.pick_random())

func _process(delta):
	if bar.value > 0 && heal >= 0:
		bar.value -= heal

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_released() && OS.get_keycode_string(event.keycode) == label.text && !is_hide:
			bar.value += 3
			if bar.value <= 20:
				heal = 0.01
				appear.wait_time = 2.0
			elif bar.value <= 40:
				heal = 0.02
				appear.wait_time = 1.9
			elif bar.value <= 60:
				heal = 0.03
				appear.wait_time = 1.7
			elif bar.value <= 80:
				heal = 0.04
				appear.wait_time = 1.5
			elif bar.value >= 100:
				dead()

func dead():
	emit_signal("deaded")
	
	appear.stop()
	disappear.stop()
	heal = 0
	
	anim.call_deferred('play', 'explose')
	control_anim.call_deferred('play', 'disappear')
	speed = 0
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_appear_timer_timeout():
	# start to disappear
	is_hide = true
	appear.stop()
	anim.play("disappear")
	await anim.animation_finished
	disappear.start()
	
func _on_disappear_timer_timeout():
	# start to appear
	is_hide = false
	disappear.stop()
	# random text and random position again
	var color = colors.pick_random()
	label.text = generate_word(characters, 1)
	# call here to set up position
	anim.play(color)
	await get_tree().create_timer(0.1).timeout
	# appear again:
	anim.play("appear")
	await anim.animation_finished
	# call here to appear
	anim.play(color)
	# make random colar for key:
	appear.start()
