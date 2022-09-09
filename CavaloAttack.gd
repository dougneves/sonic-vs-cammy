extends Node2D

export var speed = 400

func _ready():
	set_as_toplevel(true)
	$CavaloSound.play()
	$AnimatedSprite.scale = Vector2(3,3)
	position = Vector2(1100,510)

func _physics_process(delta):
	position += Vector2.LEFT * speed * delta
	
