# Spawn enermies: https://www.youtube.com/watch?v=33odP1o2N2Q

extends Node2D

const ENEMIES = [
	'basic_enemy', 'basic_enemy', 'basic_enemy',
	'fast_enemy',
	'strong_enemy',
]

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func _on_enrmies_apeartime_timeout():
	var spawn_enermy = load('res://enemies/' + str(ENEMIES.pick_random()) + '.tscn')
	var pos_list = get_tree().get_nodes_in_group('spawn')
	
	var instance = spawn_enermy.instantiate()
	var pick_pos = pos_list.pick_random()
	
	instance.z_index = pick_pos.get_z_index()
	instance.global_position = pick_pos.global_position
	
	add_child(instance)



