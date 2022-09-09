extends Node2D

const CavaloAttackScene = preload("res://CavaloAttack.tscn");

export var life = 5000

var status = 0

func _process(delta):
	if($DamageTimer.is_stopped()):
		$AnimatedSprite.modulate = Color(1,1,1,1)
		
	if(life<=0):
		queue_free()
	elif(life<=4000 && status == 0):
		status = 1
		
	if(status == 1):
		$AnimatedSprite.play("death")

func _on_hitbox_area_entered(area):
	area.get_parent().queue_free()
	$BulletHitSound.play()
	if($DamageTimer.is_stopped()):
		life -= 50
		$DamageTimer.start()
		$AnimatedSprite.modulate = Color(10,10,10)


func _on_AnimatedSprite_animation_finished():
	print($AnimatedSprite.animation)
	if(status == 1):
		status = 2
		$AnimatedSprite.play("reborn")
	else:
		$AnimatedSprite.play("idle")

func _on_AttackTimer_timeout():
	add_child(CavaloAttackScene.instance())
