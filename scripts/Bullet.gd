extends Node2D

export var speed = 1000
export var direction = Vector2.RIGHT

func _ready():
	set_as_toplevel(true)
	$Sprite.scale.x = sign(direction.x)
	$BulletShootSound.play()

func _physics_process(delta):
	position += direction * speed * delta

func area_entered(hitbox: HitBox):
	print(hitbox.id)
	queue_free()
