extends CharacterBody2D
class_name Player

@export var moveData : Resource = preload("res://DefaultPlayerMovmentData.tres") as PlayerMovementData
@onready var animatedSprite: = $AnimatedSprite2D
@onready var ladderCheck: = $LadderCheck
@onready var jumpBuffferTimer: = $JumpBufferTimer
@onready var coyoteJumpTimer: = $CoyoteJumpTimer

enum { MOVE, CLIMB }
var state = MOVE
var double_jump = 0
var buffered_jump = false
var coyote_jump = false

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
	if not horizontal_move(input):
		animatedSprite.play("Idle")
		apply_friction();
	else:
		animatedSprite.play("Run")
		apply_acceleration(input.x);
		animatedSprite.flip_h = input.x > 0
	
	if is_on_floor(): 
		reset_double_jump()
	else: 
		animatedSprite.play("Jump")
		
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall()
	
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if is_on_floor() and was_in_air:
		animatedSprite.play("Run")
		animatedSprite.set_frame(1)
		
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input):
	if not is_on_ladder(): state = MOVE
	
	print(input)
	if input.x != 0 or input.y != 0:
		animatedSprite.play("Run")
	else:
		animatedSprite.play("Idle")

	velocity = input * moveData.CLIMB_SPEED
	move_and_slide()

func input_jump_release():
	if Input.is_action_just_released("up") and velocity.y < moveData.JUMP_RELEASE_FORCE: 
		velocity.y = moveData.JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("up") and double_jump > 0:
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1;
		
func buffer_jump():
	if Input.is_action_just_pressed("up"):
		buffered_jump = true;
		jumpBuffferTimer.start()
		
func fast_fall():
	if velocity.y > 0:
		velocity.y += moveData.ADDITIONAL_FALL_GRAVITY

func can_jump():
	return is_on_floor() or coyote_jump

func horizontal_move(input):
	return input.x != 0

func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT

func input_jump():
		if Input.is_action_just_pressed("up") or buffered_jump == true:
			velocity.y = moveData.JUMP_FORCE
			buffered_jump = false

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
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)
	pass

func _on_jump_buffer_timer_timeout():
	buffered_jump = false

func _on_coyote_jump_timer_timeout():
	coyote_jump = false # Replace with function body.
