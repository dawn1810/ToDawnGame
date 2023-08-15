extends VBoxContainer

var curr_health := 10

func _damage(amount):
	if curr_health > 0:
		# avoid have negative health
		if amount > curr_health:
			amount = curr_health
		
		for i in range(amount):
			if curr_health > 5:
				get_node("HBoxContainer2/heard" + str(curr_health)).hide()
			else:
				get_node("HBoxContainer/heard" + str(curr_health)).hide()
			curr_health -= 1

func _heal(amount):
	# avoid heal more than max health
	if amount > 10 - curr_health:
		amount = 10 - curr_health
	
	for i in range(amount):
		curr_health += 1
		if curr_health < 5:
			get_node("HBoxContainer/heard" + str(curr_health)).show()
		else:
			get_node("HBoxContainer2/heard" + str(curr_health)).show()
