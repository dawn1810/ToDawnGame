extends ENEMIES


const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const colors = ['idle', 'idle_2']

@onready var label = $key/Label
@onready var anim = $AnimationPlayer

func _ready():
# random text for character:
	label.text = generate_word(characters, 1)
# make random color for key:
	match colors.pick_random():
		'idle':
			label.modulate = '5c2a00'
			anim.play('idle')
		'idle_2':
			label.modulate = 'ffeddc'
			anim.play('idle_2')

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed && OS.get_keycode_string(event.keycode) == label.text:
			play_audio()
			rand_gift()
			dead()

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



