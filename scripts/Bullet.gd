extends Node2D

export var speed = 1000
export var direction = Vector2.RIGHT
export var damage = 14

func _ready():
	set_as_toplevel(true)
	$HitBox.damage = damage
	$HitBox.id = "bullet"
	$Sprite.scale.x = sign(direction.x)
	$BulletShootSound.play()

func _physics_process(delta):
	position += direction * speed * delta

func area_entered(hitbox: HitBox):
	queue_free()
