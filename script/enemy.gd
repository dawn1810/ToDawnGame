extends ENEMIES


var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
var colors = ['idle', 'idle_2']

@onready var label = $key/Label
@onready var anim = $AnimationPlayer

func _ready():
# random text for character:
	label.text = generate_word(characters, 1);
# make random colar for key:
	anim.play(colors.pick_random())

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed && OS.get_keycode_string(event.keycode) == label.text:
			dead()

func dead():
	anim.play("explose")
	speed = 0

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word


func _on_buff_speed_body_entered(body):
	if body.is_in_group('enemy') && body != self:
		body.speed = speed
