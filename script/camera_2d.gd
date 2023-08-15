extends Camera2D


@onready var timer = $Timer

var tween: Tween
var shake_amount = 0
var default_offset = self.offset

func _ready():
	set_process(false)

func _process(delta): # causes shaking
	self.offset = Vector2(randi_range(-shake_amount, shake_amount), randi_range(shake_amount, -shake_amount)) * delta + default_offset

func shake(new_shake, shake_time = 0.4, shake_limit = 100): # starts shaking
	shake_amount += new_shake
	
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	
	timer.wait_time = shake_time
	
	if (tween):
		tween.kill()
	set_process(true)
	timer.start()

func _on_timer_timeout(): # stops shaking
	shake_amount = 0
	set_process(false)
	
	if (tween):
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'offset', default_offset, 0.1)
