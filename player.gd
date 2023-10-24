extends CharacterBody2D

var charVelocity = Vector2.ZERO

#func _ready():
#	pass
	
func _physics_process(_delta):
	velocity.y += 4
	if(Input.get_action_strength("right") == 1):
		velocity.x = 50;
	elif(Input.get_action_strength("left") == 1):
		velocity.x = -50;
	else:
		velocity.x = 0;
	
	if(Input.is_action_just_pressed("up")):
		velocity.y = -100
	
	move_and_slide()
	print(velocity.y)
	
