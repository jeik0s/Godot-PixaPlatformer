extends CharacterBody2D

@export var JUMP_FORCE : int = -130
@export var JUMP_RELEASE_FORCE : int = -70
@export var MAX_SPEED : int = 50
@export var ACCELERATION : int = 10
@export var FRICTION : int = 10
@export var GRAVITY : int = 4
@export var ADDITIONAL_FALL_GRAVITY : int = 4
@export var BUNNY_HOP : bool = true

var charVelocity = Vector2.ZERO

func _physics_process(_delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left");
	
	if input.x == 0:
		apply_friction();
	else:
		apply_acceleration(input.x);
	
	if is_on_floor():
		if BUNNY_HOP:
			if Input.is_action_pressed("up"):
				velocity.y = JUMP_FORCE
		else:
			if Input.is_action_just_pressed("up"):
				velocity.y = JUMP_FORCE
				
	else:
		if Input.is_action_just_released("up") and velocity.y < JUMP_RELEASE_FORCE: 
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	move_and_slide()
	
func apply_gravity():
		velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	pass
	
func apply_acceleration(amout):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amout, ACCELERATION)
	pass