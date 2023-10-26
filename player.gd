extends CharacterBody2D

@export var JUMP_FORCE : int = -130
@export var JUMP_RELEASE_FORCE : int = -70
@export var MAX_SPEED : int = 50
@export var ACCELERATION : int = 10
@export var FRICTION : int = 10
@export var GRAVITY : int = 4
@export var ADDITIONAL_FALL_GRAVITY : int = 4
@export var BUNNY_HOP : bool = true

@onready var animatedSprite = $AnimatedSprite2D

# enum ANIMATION_STATE {IDLE, RUN}

var charVelocity = Vector2.ZERO

func _ready():
	animatedSprite.play("Idle")
	
	# CHECK ME!
	# check how to change sprite
	# animatedSprite.name("res://PlayerGreenSkin.tres")

func _physics_process(_delta):
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left");
	
	if input.x == 0:
		animatedSprite.play("Idle")
		apply_friction();
	else:
		animatedSprite.play("Run")
		apply_acceleration(input.x);
		
		if input.x > 0:
			animatedSprite.set_flip_h(true)
		elif input.x < 0:
			animatedSprite.set_flip_h(false)
	
	if is_on_floor():
		if BUNNY_HOP:
			if Input.is_action_pressed("up"):
				velocity.y = JUMP_FORCE
		else:
			if Input.is_action_just_pressed("up"):
				velocity.y = JUMP_FORCE
				
	else:
		animatedSprite.play("Jump")
		if Input.is_action_just_released("up") and velocity.y < JUMP_RELEASE_FORCE: 
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
			
	var was_in_air = not is_on_floor()
	move_and_slide()
	
	if is_on_floor() and was_in_air:
		animatedSprite.play("Run")
		animatedSprite.set_frame(1)
	
func apply_gravity():
		velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	pass
	
func apply_acceleration(amout):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amout, ACCELERATION)
	pass
