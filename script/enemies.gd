extends CharacterBody2D
class_name  ENEMIES

const FIRE = preload('res://skills/fire.tscn')
const ROCK = preload('res://skills/rock.tscn')
const TANK = preload("res://skills/tank.tscn")

@export var speed = 300.0
@export var attack_amount = 0

var move: bool = true

func _physics_process(delta):
	if move:
		velocity = Vector2.LEFT * speed
		move_and_slide()

func dead():
# add dead animation here
	print('dead')

func rand_gift(anim): # input is curremt animation of current enemies type
	var rand_gift = []
	if (Global.rock > 0):
		rand_gift.append(0)
	if (Global.fire > 0):
		rand_gift.append(1)
	if (Global.tank > 0):
		rand_gift.append(4)
	if (Global.stop > 0):
		rand_gift.append(3)
	if (Global.bomb > 0):
		rand_gift.append(2)
	if (Global.heal > 0):
		rand_gift.append(5)
	match rand_gift.pick_random():
		0: 
			# appear rock gift
			var rock = ROCK.instantiate()
			rock.global_position = self.position
			rock.z_index = self.z_index
			get_parent().call_deferred('add_child', rock)
			await anim.animation_finished
			queue_free()
		1: 
			# appear fire gift
			var fire = FIRE.instantiate()
			fire.global_position = self.position
			fire.z_index = self.z_index
			get_parent().call_deferred('add_child', fire)
			await anim.animation_finished
			queue_free()
		2: 
			# destroy all enemies scene random
			var percent = 0.01
			match Global.bomb: 
				2: percent = 0.05
				3: percent = 0.1
			
			if (randf() < percent):
				var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
				if (len(enemies_appear) > 0):
					for enemy in enemies_appear:
						enemy.dead()
				await anim.animation_finished
				queue_free()
		3: 
			# pause scene
			var stop_time = 2.0
			match Global.stop: 
				2: stop_time = 5.0
				3: stop_time = 10.0
			
			var prev_speeds = []
			var enemies_appear = get_parent().get_tree().get_nodes_in_group('enemy')
			# stop spawm/process enemies
			get_parent().spawn_timer.stop()
			get_parent().progress_timer.stop()
			# stop all enemies exist
			if (len(enemies_appear) > 0):
				for enemy in enemies_appear:
					prev_speeds.append(enemy.speed)
					enemy.speed = 0
			# timer stop for ...
			await get_parent().get_tree().create_timer(stop_time).timeout
			# respawn enemies and contimue game
			get_parent().spawn_timer.start()
			get_parent().progress_timer.start()
			# reset speed for all enemies
			if (len(enemies_appear) > 0):
				for i in range(len(enemies_appear)):
					enemies_appear[i].speed = prev_speeds[i]
			await anim.animation_finished
			queue_free()
		4: 
			# appear tank gift
			var tank = TANK.instantiate()
			tank.global_position = self.position
			tank.z_index = self.z_index
			get_parent().call_deferred('add_child', tank)
			await anim.animation_finished
			queue_free()
		5: 
			print('heal roi ne!!!')

func _on_buff_speed_body_entered(body):
	if body.is_in_group('enemy') && body != self && body.speed < self.speed:
		body.speed = self.speed

