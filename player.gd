extends CharacterBody2D
class_name Player

@export var moveData : Resource 
@onready var animatedSprite = $AnimatedSprite2D
@onready var ladderCheck = $LadderCheck

enum { MOVE, CLIMB }
var state = MOVE

func _ready():
	animatedSprite.play("Idle")
	# CHECK ME!
	# check how to change sprite
	# animatedSprite.name("res://PlayerGreenSkin.tres")

func _physics_process(_delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("left","right")
	input.y = Input.get_axis("up","down")
	
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)

func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("up"):
		state = CLIMB
	
	apply_gravity()
	if input.x == 0:
		animatedSprite.play("Idle")
		apply_friction();
	else:
		animatedSprite.play("Run")
		apply_acceleration(input.x);
		
		animatedSprite.flip_h = input.x > 0
	
	
	if is_on_floor():
		if moveData.BUNNY_HOP:
			if Input.is_action_pressed("up"):
				velocity.y = moveData.JUMP_FORCE
		else:
			if Input.is_action_just_pressed("up"):
				velocity.y = moveData.JUMP_FORCE
				
	else:
		animatedSprite.play("Jump")
		if Input.is_action_just_released("up") and velocity.y < moveData.JUMP_RELEASE_FORCE: 
			velocity.y = moveData.JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
			
	var was_in_air = not is_on_floor()
	move_and_slide()
	
	if is_on_floor() and was_in_air:
		animatedSprite.play("Run")
		animatedSprite.set_frame(1)
	
func climb_state(input):
	if not is_on_ladder(): state = MOVE
	
	print(input)
	if input.x != 0 or input.y != 0:
		animatedSprite.play("Run")
	else:
		animatedSprite.play("Idle")

	velocity = input * 50
	move_and_slide()

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
		
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	
	return true

func apply_gravity():
		velocity.y += moveData.GRAVITY
		velocity.y = min(velocity.y, 300)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)
	pass
	
func apply_acceleration(amout):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amout, moveData.ACCELERATION)
	pass
