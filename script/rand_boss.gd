extends ENEMIES

signal deaded

@export var basic = preload("res://enemies/basic_enemy.tscn")
@export var fast = preload("res://enemies/fast_enemy.tscn")
@export var strong = preload("res://enemies/strong_enemy.tscn")
@export var hide = preload("res://enemies/hidden_enemy.tscn")
@export var hover = preload("res://enemies/hover_enemy.tscn")
@export var rand = preload("res://enemies/rand_letter_enemy.tscn")

const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

var freq = [.5, .3, .2, .2, .1, .1]

@onready var label = $key/Label
@onready var anim = $AnimationPlayer

func _ready():
# random text for character:
	label.text = generate_word(characters, 1)
	
	var pos_list = get_tree().get_nodes_in_group('boss_pos')
	
	for i in pos_list:
		spawn_enemies(i.global_position)
	

func rand_enemies(freq) -> int:
	var total: float
	for i in freq:
		total += i
	
	for i in range(len(freq)):
		if randf_range(.0, total) >= total - freq[i]: 
			return i
			break
		if i == len(freq) - 1: return i;
		total -= freq[i]
	return -1

func spawn_enemies(pos):
	var spawn_enermy: PackedScene
	match rand_enemies(freq):
		0: spawn_enermy = basic
		1: spawn_enermy = fast
		2: spawn_enermy = strong
		3: spawn_enermy = hide
		4: spawn_enermy = hover
		5: spawn_enermy = rand
	
	var instance = spawn_enermy.instantiate()
	
	add_child(instance)
	instance.move = false
	instance.global_position = pos

func _unhandled_input(event):
# make enermies be kill by enter a key on them head:
	if event is InputEventKey:
		if event.pressed && OS.get_keycode_string(event.keycode) == label.text && self.get_child_count() <= 6:
			dead()

func dead():
	emit_signal("deaded")
	
	anim.play("explose")
	speed = 0
	
	# clear all enemies on stage
	var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
	var boss_enemies = get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()
	if (len(boss_enemies) > 0):
		for enemy in boss_enemies:
			enemy.dead()

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word



