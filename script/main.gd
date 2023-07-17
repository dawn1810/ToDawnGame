# Spawn enermies: https://www.youtube.com/watch?v=33odP1o2N2Q

extends Node2D

const ENEMIES = [
	'basic_enemy', 'basic_enemy', 'basic_enemy', 'basic_enemy', 'basic_enemy',
	'fast_enemy',
	'strong_enemy',
]

const ENEMIES_2 = [
	'basic_enemy', 'basic_enemy', 'basic_enemy', 'basic_enemy', 'basic_enemy',
	'fast_enemy',
	'strong_enemy',
	'hover_enemy',
	'rand_letter_enemy',
]

const ENEMIES_3 = [
	'basic_enemy', 'basic_enemy', 'basic_enemy',
	'fast_enemy', 'fast_enemy',
	'strong_enemy', 'strong_enemy',
	'hover_enemy',
	'rand_letter_enemy',
]

@onready var spawn_timer = $enemiesApeartime
@onready var progress_timer = $progressTimer
@onready var bar = $Ontop/TextureProgressBar

var enemies = ENEMIES
var stage = 0

func _ready():
	spawn_timer.set_wait_time(1.5)
	var tween = get_tree().create_tween()
	tween.tween_property(bar, 'value', 100, progress_timer.wait_time * 6)

func _on_enrmies_apeartime_timeout():
	var spawn_enermy = load('res://enemies/' + str(enemies.pick_random()) + '.tscn')
	var pos_list = get_tree().get_nodes_in_group('spawn')
	
	var instance = spawn_enermy.instantiate()
	var pick_pos = pos_list.pick_random()
	
	instance.z_index = pick_pos.get_z_index()
	instance.global_position = pick_pos.global_position
	
	add_child(instance)

func _on_progress_timer_timeout():
	stage += 1
	if stage == 1:
		enemies = ENEMIES_2
	elif stage == 3:
		spawn_timer.set_wait_time(1.2)
	elif  stage == 4:
		enemies = ENEMIES_3
	elif  stage == 6:
		print('boss fight')
