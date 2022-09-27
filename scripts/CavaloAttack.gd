extends Node2D

export var speed = 400
export var life = 50

func _ready():
	set_as_toplevel(true)
	$CavaloSound.play()
	$AnimatedSprite.scale = Vector2(3,3)
	position = Vector2(1100,510)

func _physics_process(delta):
	position += Vector2.LEFT * speed * delta
	$AnimatedSprite.modulate = Color(1,1,1)
	if(life <= 0):
		queue_free()
	
func area_entered(hitbox: HitBox):
	life -= hitbox.damage
	$AnimatedSprite.modulate = Color(10,10,10)
