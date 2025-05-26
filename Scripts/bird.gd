extends CharacterBody2D

const GRAVITY: int = 2000
const MAX_VEL: int = 1600
const FLAP_SPEED: int = -800
var flying: bool = false
var falling: bool = false
var START_POS := Vector2(360.0, 637.5)

func _ready() -> void:
	reset()

func _physics_process(delta: float) -> void:
	if flying or falling:
		velocity.y += GRAVITY * delta
		#terminal velocity
		velocity.y = clamp(velocity.y, FLAP_SPEED, MAX_VEL)
		
		if flying:
			rotation = deg_to_rad(velocity.y * 0.05)
		elif falling:
			rotation = PI/2
		
		move_and_slide()

func reset() -> void:
	falling = false
	flying = false
	position = START_POS
	rotation = 0

func flap() -> void:
	$FlapSound.play()
	velocity.y = FLAP_SPEED
