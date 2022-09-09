extends KinematicBody2D

const BulletScene = preload("res://Bullet.tscn");

const UP_DIRECTION = Vector2.UP;

var speed = 600

export var jump_strength = 1500
export var max_jumps = 2
export var double_jump_strength = 1200
export var gravity = 4500

var _jumps_made = 0
var _velocity = Vector2.ZERO

onready var _animation_player = $AnimatedSprite

func _physics_process(delta):
	var horizontal_direction = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	
	_velocity.x = horizontal_direction * speed
	_velocity.y += gravity*delta
		
	var is_falling = _velocity.y > 0 && !is_on_floor()
	var is_jumping = Input.is_action_just_pressed("jump") && is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("jump") && is_falling
	var is_jumping_cancelled = Input.is_action_just_released("jump")
	var is_idling = is_on_floor() && is_zero_approx(_velocity.x)
	var is_running = is_on_floor() && !is_zero_approx(_velocity.x)
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
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	
	if !is_zero_approx(_velocity.x):
		_animation_player.scale.x = sign(_velocity.x)
		
	if !is_on_floor():
		_animation_player.play("jump")
	if is_running:
		_animation_player.play("walk")
	if is_idling:
		_animation_player.play("idle")
	
func _on_Area2D_area_entered(area):
	print(area)
