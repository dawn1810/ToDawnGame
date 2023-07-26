# Spawn enermies: https://www.youtube.com/watch?v=33odP1o2N2Q

extends Node2D

# enemies
@export var basic = preload("res://enemies/basic_enemy.tscn")
@export var fast = preload("res://enemies/fast_enemy.tscn")
@export var strong = preload("res://enemies/strong_enemy.tscn")
@export var hide = preload("res://enemies/hidden_enemy.tscn")
@export var hover = preload("res://enemies/hover_enemy.tscn")
@export var rand = preload("res://enemies/rand_letter_enemy.tscn")

# boss
@export var rand_boss = preload("res://enemies/rand_boss.tscn")
@export var box_boss = preload("res://enemies/box_enemy.tscn")
@export var mouse_boss = preload("res://enemies/mouse_boss.tscn")
@export var path_boss = preload("res://enemies/path_boss.tscn")

# propability to generate thoes enemies
var freq = [.7, .4]
var cst = 2.0
var pos_list = []
var enemies = ENEMIES
var stage = 0
var tween: Tween

@onready var spawn_timer = $enemiesApeartime
@onready var progress_timer = $progressTimer
@onready var bar = $Ontop/TextureProgressBar
@onready var center_point = $spawnPositions/Marker2D5


func _ready():
	spawn_timer.set_wait_time(cst)
	pos_list = get_tree().get_nodes_in_group('spawn')
	if (tween):
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(bar, 'value', 100, progress_timer.wait_time * 2)

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

func reset_tween():
		# when bar full it will return show the the next turn
	if (tween):
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(bar, 'value', 0, 0.5)
	await tween.finished
	tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(bar, 'value', 100, progress_timer.wait_time * 2)

func boss_render():
	# stop spawn enemies first
	spawn_timer.stop()
	# spawn less enemies in boss face: 
	spawn_timer.set_wait_time(cst * 2)
	# stop process bar because it make stage + one every boss stage
	progress_timer.stop()
	
	var spawn_boss: PackedScene
	match randi_range(3, 3):
		0: 
			spawn_boss = rand_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			spawn_timer.start()
		1: 
			spawn_boss = box_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D3, 
				$spawnPositions/Marker2D4,
				$spawnPositions/Marker2D6, 
				$spawnPositions/Marker2D7,
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			spawn_timer.start()
		2: 
			spawn_boss = mouse_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D3, 
				$spawnPositions/Marker2D7,
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			spawn_timer.start()
		3:
			spawn_boss = path_boss
	
	var instance = spawn_boss.instantiate()
	
	instance.z_index = center_point.get_z_index()
	instance.global_position = center_point.global_position
	
	add_child(instance)
	
	# connect to dead signal
	instance.deaded.connect(_on_boss_deaded)

func _on_enrmies_apeartime_timeout():
	var spawn_enermy: PackedScene
	match rand_enemies(freq):
		0: spawn_enermy = basic
		1: spawn_enermy = fast
		2: spawn_enermy = strong
		3: spawn_enermy = hide
		4: spawn_enermy = hover
		5: spawn_enermy = rand
	
	var instance = spawn_enermy.instantiate()
	var pick_pos = pos_list.pick_random()
	
	instance.z_index = pick_pos.get_z_index()
	instance.global_position = pick_pos.global_position
	
	add_child(instance)

func _on_progress_timer_timeout():
	stage += 1
	if stage <= 3:
		if stage == 1:
			spawn_timer.set_wait_time(cst * 2/3)
			freq = [.5, .3, .2, .2]
		elif stage == 2:
			boss_render()
			cst -= 0.2 # low 0.2 spawn time after boss
			spawn_timer.set_wait_time(cst)
		elif  stage == 3:
			spawn_timer.set_wait_time(cst * 2/3)
			freq = [.5, .3, .2, .2, .1, .1]
	else:
		if stage % 2 == 0:
			boss_render()
			cst -= 0.2 # low 0.2 spawn time after boss
			spawn_timer.set_wait_time(cst)
		else:
			spawn_timer.set_wait_time(cst * 2/3)

func _on_boss_deaded():
	if spawn_timer.is_stopped():
		spawn_timer.start()
	progress_timer.start()
	# reset pos_list (position spawn enemies)
	pos_list = get_tree().get_nodes_in_group('spawn')
	reset_tween()
