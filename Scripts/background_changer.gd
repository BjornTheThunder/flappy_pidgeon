extends Sprite2D

const BACKGROUND_1 = preload("res://Sprites/Level/Background1.png")
const BACKGROUND_2 = preload("res://Sprites/Level/Background2.png")
const BACKGROUND_3 = preload("res://Sprites/Level/Background5.png")

func random_background(rand_num) -> void:
	if rand_num == 0:
		texture = BACKGROUND_1
	elif rand_num == 1:
		texture = BACKGROUND_2
	else:
		texture = BACKGROUND_3
