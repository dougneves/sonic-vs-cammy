extends KinematicBody2D

const BulletScene = preload("res://scenes/Bullet.tscn");

const UP_DIRECTION = Vector2.UP;

var _speed = 0

export var jump_strength = 1500
export var max_jumps = 2
export var double_jump_strength = 1200
export var gravity = 4500
export var max_speed = 600
export var acc = 2000

var _jumps_made = 0
var _velocity = Vector2.ZERO

onready var _animation_player = $AnimatedSprite

func _physics_process(delta):
	if(Input.is_action_pressed("move_right")):
		_speed = lerp(_speed, max_speed, .1)
	elif(Input.is_action_pressed("move_left")):
		_speed = lerp(_speed, -max_speed, .1)
	else:
		_speed = lerp(_speed, 0, .1)
		
	_velocity.y += gravity*delta
		
	var is_falling = _velocity.y > 0 && !is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") && is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") && is_falling
	var is_jumping_cancelled = Input.is_action_just_released("jump")
	var is_idling = is_on_floor() && (abs(_velocity.x) < 25)
	var is_running = is_on_floor() && (abs(_velocity.x) > 25)
	var is_shooting = Input.is_action_pressed("attack")
	
	if(is_shooting && $ShootingTimer.is_stopped()):
		$ShootingTimer.start()
		var bullet_instance = BulletScene.instance()
		bullet_instance.position.x = position.x + (_animation_player.scale.x*10)
		bullet_instance.position.y = position.y - 10
		if(_animation_player.scale.x > 0):
			bullet_instance.direction = Vector2.RIGHT
		else:
			bullet_instance.direction = Vector2.LEFT
		bullet_instance.z_index = 1000
		add_child(bullet_instance)
	
	if is_jumping:
		_jumps_made+=1
		_velocity.y = -jump_strength
	elif is_double_jumping:
		_jumps_made+=1
		if _jumps_made <= max_jumps:
			_velocity.y = -double_jump_strength
	elif is_jumping_cancelled && _velocity.y < 0:
		_velocity.y = 0
	elif is_on_floor():
		_jumps_made = 0
	
	_velocity.x = _speed
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
	if !is_zero_approx(_velocity.x):
		_animation_player.scale.x = sign(_velocity.x)
		
	if !is_on_floor():
		_animation_player.play("jump")
	elif is_running:
		_animation_player.play("walk")
	elif is_idling:
		_animation_player.play("idle")
	
func area_entered(hitbox: HitBox):
	_animation_player.play("hurt")
	$HurtSound.play(0.4)
	$HurtBox.collision_mask = 0
	$HurtTimer.start()
	_speed = -1500
	_velocity = move_and_slide(Vector2(-1500,-1500))


func _on_HurtTimer_timeout():
	$HurtBox.collision_mask = 21
