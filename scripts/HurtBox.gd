class_name HurtBox
extends Area2D

export var id = "generic"

func _init():
	pass

func _ready():
	connect("area_entered", self, "_hurtbox_area_entered")
	
func _hurtbox_area_entered(hitbox: HitBox):
	if hitbox && owner.has_method("area_entered"):
		owner.area_entered(hitbox)
