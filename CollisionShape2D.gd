extends CollisionShape2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

func _ready():
	pass

func _physics_process(_delta):
	velocity = direction * 25
	move_and_slide()
