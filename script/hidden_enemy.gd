extends ENEMIES


const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

@onready var label = $key/Label
@onready var anim = $AnimationPlayer
@onready var timer = $Timer

func _ready():
	anim.play("RESET")
# random text for character:
	label.text = generate_word(characters, 1)
# random time to appear from 1 to 3 seconds
	timer.wait_time = randf_range(1.0, 4.0)
	timer.start()


func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed && OS.get_keycode_string(event.keycode) == label.text:
			dead()

func dead():
	anim.call_deferred('play', 'explose')
	speed = 0

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_timer_timeout():
	anim.play("change_letter")
	await anim.animation_finished
	# make random colar for key:
	anim.play(colors.pick_random())
