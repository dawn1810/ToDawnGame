extends ENEMIES

@onready var label = $Label

var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'


func _ready():
# random text for character:
	label.text = generate_word(characters, 1);
# make enermies be kill by enter a key on them head:

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed && OS.get_keycode_string(event.keycode) == label.text:
			dead()

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word
