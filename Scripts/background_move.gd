extends Sprite2D

const MOVEMENT_SPEED: int = 12
var background_width

func _ready() -> void:
	background_width = texture.get_width()

func _process(delta: float) -> void:
	position.x -= MOVEMENT_SPEED * delta
	
	if position.x <= -background_width:
		position.x = 0
