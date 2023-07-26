extends StaticBody2D

@onready var rock = $Sprite2D
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# random art for rocks
	rock.frame = randi_range(0, 5)

func _on_timer_timeout():
	anim.call_deferred('play', 'disappear')
