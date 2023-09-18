# Spawn enermies: https://www.youtube.com/watch?v=33odP1o2N2Q

extends Node2D


const healing_sound = preload("res://audio/heal_audio.mp3")
const pause_sound1 = preload("res://audio/pause_audio/tictac_audio01.mp3")
const pause_sound2 = preload("res://audio/pause_audio/tictac_audio02.mp3")
const pause_sound3 = preload("res://audio/pause_audio/tictac_audio03.mp3")

const background_music1 = preload("res://audio/background_audio.mp3")
const background_music2 = preload("res://audio/background_audio2.mp3")
const background_music3 = preload("res://audio/background_audio3.mp3")

# enemies
@export var basic = preload("res://enemies/basic_enemy.tscn")
@export var fast = preload("res://enemies/fast_enemy.tscn")
@export var strong = preload("res://enemies/strong_enemy.tscn")
@export var hide = preload("res://enemies/hidden_enemy.tscn")
@export var hover = preload("res://enemies/hover_enemy.tscn")
@export var rand = preload("res://enemies/rand_letter_enemy.tscn")
@export var word = preload("res://enemies/word_enemy.tscn")

# boss
@export var rand_boss = preload("res://enemies/rand_boss.tscn")
@export var box_boss = preload("res://enemies/box_enemy.tscn")
@export var mouse_boss = preload("res://enemies/mouse_boss.tscn")
@export var path_boss = preload("res://enemies/path_boss.tscn")
@export var order_boss = preload("res://enemies/order_boss.tscn")

# propability to generate thoes enemies
var freq = [.7, .4]
var cst = 5.0
var pos_list = []
var enemies = ENEMIES
var stage = 0
var tween: Tween
var lose: bool
var enemy_speed: int = 100

@onready var spawn_timer = $enemiesApeartime
@onready var progress_timer = $progressTimer
@onready var bar = $Ontop/TextureProgressBar
@onready var center_point = $spawnPositions/Marker2D5
@onready var gameover_scene = $Ontop/GameOver
@onready var anim = $AnimationPlayer
@onready var lucky_scroll = $Ontop/luckyScroll
@onready var camera = $Camera2D
@onready var health_bar = $Ontop/HBoxContainer/heardBar
@onready var soundfx = $audio/soundfx
@onready var music = $audio/music
@onready var paused_scene = $Ontop/pause_scene


func _ready():
	# play random music
	rand_background_music()
	
	lose = false
	
	spawn_timer.set_wait_time(cst)
	pos_list = get_tree().get_nodes_in_group('spawn')
	if (tween):
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(bar, 'value', 100, progress_timer.wait_time * 2)

func rand_background_music():
	match randi_range(0, 2):
		0: music.stream = background_music1
		1: music.stream = background_music2
		2: music.stream = background_music3
	
	music.play()

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
	# clear all enemies on stage
	var enemies_appear = get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()
	
	# stop spawn enemies first
	spawn_timer.stop()
	# stop process bar because it make stage + one every boss stage
	progress_timer.stop()
	
	var spawn_boss: PackedScene
	match randi_range(0, 4):
		0: 
			spawn_boss = rand_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D9
				]
			spawn_timer.start()
		1: 
			spawn_boss = box_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D3,  
				$spawnPositions/Marker2D7,
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			# spawn less enemies in boss face: 
			spawn_timer.set_wait_time(cst)
			spawn_timer.start()
		2: 
			spawn_boss = mouse_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			# spawn less enemies in boss face: 
			spawn_timer.set_wait_time(cst * 2)
			spawn_timer.start()
		3:
			spawn_boss = path_boss
		4: 
			spawn_boss = order_boss
			pos_list = [
				$spawnPositions/Marker2D, 
				$spawnPositions/Marker2D2, 
				$spawnPositions/Marker2D8,
				$spawnPositions/Marker2D9
				]
			# spawn less enemies in boss face: 
			spawn_timer.set_wait_time(cst * 3)
			spawn_timer.start()
	
	var instance = spawn_boss.instantiate()
	
	instance.z_index = center_point.get_z_index()
	instance.global_position = center_point.global_position
	
	add_child(instance)
	
	# connect to dead signal
	instance.deaded.connect(_on_boss_deaded)

func game_over():
	if !lose:
		lose = true
		
		# clear/remove all map (enemies, bosses, skills)
		var enemies_appear = get_tree().get_nodes_in_group('enemy')
		var skills_appear = get_tree().get_nodes_in_group('skill_appear')
		var bosses_appear = get_tree().get_nodes_in_group('boss')
		if (len(enemies_appear) > 0):
			for enemy in enemies_appear:
				enemy.dead()
		if (len(skills_appear) > 0):
			for skill in skills_appear:
				skill.dead()
		if (len(bosses_appear) > 0):
			for boss in bosses_appear:
				boss.dead()
		
		# reset all gameover skills
		Global.fire = 0
		Global.rock = 0
		Global.bomb = 0
		Global.stop = 0
		Global.tank = 0
		Global.heal = 0
		
		spawn_timer.stop()
		progress_timer.stop()
		camera.shake(500, 1.0, 1000)
		anim.play("gameover")
		# focus on gameover
		gameover_scene.game_over_focus()
		
func disable_pos(node: Marker2D, length: int):
	pos_list.erase(node)
	await get_tree().create_timer(length).timeout
	if !progress_timer.is_stopped():
		pos_list.append(node)

func _on_enrmies_apeartime_timeout():
	if len(pos_list) > 0:
		var spawn_enermy: PackedScene
		var pick_pos = pos_list.pick_random()
		if randf() > 0.7:
			match rand_enemies(freq):
				0: spawn_enermy = basic
				1: spawn_enermy = fast
				2: spawn_enermy = strong
				3: spawn_enermy = hide
				4: spawn_enermy = hover
				5: spawn_enermy = rand
		else:
			spawn_enermy = word
		
		var instance = spawn_enermy.instantiate()
		
		instance.speed = enemy_speed
		
		instance.global_position = pick_pos.global_position
		
		add_child(instance)
		
		# connect to signals to main
		instance.stop_time.connect(_on_time_stop)
		instance.healing.connect(_on_healing)
		
		
		if spawn_enermy == word:
			# delay time for child to appear all (avoid two enemies stay on another)
			# delay time base on enemy's length and current spawn time 
			# (5.0 is start spawn time/ current spawn tiem) = current percent
			disable_pos(pick_pos, instance.rand_word.length() * (5.0/cst))

func _on_progress_timer_timeout():
	stage += 1
	if stage <= 3:
		if stage == 1:
			spawn_timer.set_wait_time(cst * 2/3)
			freq = [.5, .3, .2, .2]
		elif stage == 2:
			# render boss
			boss_render()
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
	# clear all enemies on stage
	var enemies_appear = get_tree().get_nodes_in_group('enemy')
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			enemy.dead()
	
	camera.shake(500, 1.0, 1000)
	# start scrolling face to choose skill
	lucky_scroll._scrolling()

func restart_game_after_scroll():
	cst -= 0.2 # low 0.2 spawn time after boss
	enemy_speed += 5
	spawn_timer.set_wait_time(cst)
	
	if spawn_timer.is_stopped():
		spawn_timer.start()
	progress_timer.start()
	# reset pos_list (position spawn enemies)
	pos_list = get_tree().get_nodes_in_group('spawn')
	reset_tween()

func _on_tower_game_over():
	game_over()

func _on_time_stop():
	var stop_time = 2.0
	match Global.stop: 
		2: stop_time = 5.0
		3: stop_time = 10.0
	
	var prev_speeds = []
	var enemies_appear = get_tree().get_nodes_in_group('enemy')
	# stop spawm/process enemies
	spawn_timer.stop()
	progress_timer.stop()
	tween.stop()
	# stop all enemies exist
	if (len(enemies_appear) > 0):
		for enemy in enemies_appear:
			prev_speeds.append(enemy.speed)
			enemy.speed = 0
	
	# random audio:
	match randi_range(0, 2):
		0: soundfx.stream = pause_sound1
		1: soundfx.stream = pause_sound2
		2: soundfx.stream = pause_sound3
	
	# play tictac audio
	soundfx.play() 
	
	# timer stop for ...
	await get_tree().create_timer(stop_time).timeout
	
	# stop audio
	soundfx.stop()
	soundfx.stream = null
	
	# respawn enemies and contimue game
	spawn_timer.start()
	progress_timer.start()
	tween.play()
	# reset speed for all enemies
	if (len(enemies_appear) > 0):
		for i in range(len(enemies_appear)):
			if is_instance_valid(enemies_appear[i]): #Detect if an object reference is Freed?
				enemies_appear[i].speed = prev_speeds[i]

func _on_healing():
	# play healing audio and animation
	soundfx.stream = healing_sound
	soundfx.play()
	anim.play("healing")
	
	match Global.heal:
		1: health_bar._heal(1)
		2: health_bar._heal(2)
		3: health_bar._heal(3)

func _on_music_finished():
	# start new random background musics
	rand_background_music()
