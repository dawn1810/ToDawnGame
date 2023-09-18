extends ENEMIES


const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

var running: bool = false

@onready var label = $key/Label
@onready var timer = $deadTimer
@onready var bar = $deadBar
@onready var anim = $AnimationPlayer

var tween: Tween

func _ready():
# random text for character:
	label.text = generate_word(characters, 1)
# make random color for key:
	match colors.pick_random():
		'idle':
			label.modulate = 'ffeddc'
			anim.play('idle')
		'idle_2':
			label.modulate = '5c2a00'
			anim.play('idle_2')
# random timer wait_time
	timer.wait_time = randf_range(0.5, 1.0)
# make deadBar unvisible
	bar.visible = false

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.is_pressed() && OS.get_keycode_string(event.keycode) == label.text:
			if !running:
				timer.start()
				bar.visible = true
				running = true
				if tween:
					tween.kill() # Abort the previous animation.
				tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
				tween.tween_property(bar, 'value', 100, timer.wait_time - 0.1)
		if event.is_released() && OS.get_keycode_string(event.keycode) == label.text:
#			reset timer
			if running:
				play_audio()
				timer.stop()
				timer.set_wait_time(1.0)
				running = false
				if tween:
					tween.kill() # Abort the previous animation.
				tween = create_tween()
				tween.tween_property(bar, 'value', 0, 0.5)
				await tween.finished
				bar.visible = false

func dead():
	play_audio()
	anim.call_deferred('play', 'explose')
	speed = 0

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_dead_timer_timeout():
	running = false
	rand_gift()
	dead()
