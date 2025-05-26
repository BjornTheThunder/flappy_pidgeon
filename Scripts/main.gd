extends Node

var config = ConfigFile.new()

const PIPE = preload("res://Objects/pipe.tscn")

var random_background_active: bool = true
var game_running: bool
var game_over: bool
var scroll

var score: int
var best_score: int
var flap_count: int = 0

const SCROLL_SPEED: int = 400
var screen_size: Vector2
var ground_height: int = 50
var pipes: Array
const PIPE_DELAY: int = 300
const PIPE_RANGE: int = 160

const BACKGROUND_MOVEMENT_SPEED: int = 18
var background_width

var score_label
var best_score_label
var best_score_menu_label

var backgrounds

func _ready() -> void:
	screen_size = Vector2(720, 1275)
	background_width = $Background.texture.get_width() * 5.0 #scale of the background
	backgrounds = [$Background, $Background2]
	
	score_label = $GameOverUI/ColorRect/ScoreShowUI/Label/ScoreLabel
	best_score_label = $GameOverUI/ColorRect/ScoreShowUI/Label2/BestScoreLabel
	best_score_menu_label = $MenuUI/Menu/ColorRect/VBoxContainer/Label3
	
	#Loading data
	recover_best_score()
	
	new_game()

func _process(delta: float) -> void:
	if !game_over:
		scroll += SCROLL_SPEED * delta
		if scroll > screen_size.x:
			scroll = 0
		
		for background in backgrounds:
			background.position.x -= BACKGROUND_MOVEMENT_SPEED * delta
			if background.position.x < -background_width:
				background.position.x = background_width - (BACKGROUND_MOVEMENT_SPEED * delta)
	
	$Ground.position.x = -scroll
	
	if game_running:
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED * delta
			if pipe.position.x < -PIPE_DELAY:
				pipes.remove_at(pipes.find(pipe))
				pipe.queue_free()

func _input(event: InputEvent) -> void:
	if !game_over:
		if event is InputEventScreenTouch:
			if event.pressed and event.position.y > 200:
				if !game_running:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						flap_count += 1
						check_top()

func start_game() -> void:
	$TutorialUI.hide()
	
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PipeSpawnTimer.wait_time = 3
	$PipeSpawnTimer.start()

func new_game() -> void:
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	flap_count = 0
	
	pipes.clear()
	get_tree().call_group("pipe", "queue_free")
	generate_pipe()
	
	$GameOverUI.hide()
	$TutorialUI.show()
	$CanvasLayer/ScoreLabel.text = "0"
	
	#Select random BACKGROUND
	if random_background_active:
		var rand_num = randi_range(0, 3)
		for background in backgrounds:
			background.random_background(rand_num)
	
	$Bird.reset()


func _on_pipe_spawn_timer_timeout() -> void:
	generate_pipe()

func generate_pipe() -> void:
	var pipe = PIPE.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = ((screen_size.y - ground_height) / 2) + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(score_increase)
	add_child(pipe)
	pipes.append(pipe)

func check_top() -> void:
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()

func stop_game() -> void:
	if !game_running:
		return
	
	$DeathSound.play()
	
	$GameOverUI.play_appear_animation()
	score_label.text = str(score)
	best_score_label.text = str(best_score)
	best_score_menu_label.text = str(best_score)
	
	#Saving data
	save_best_score()
	
	$PipeSpawnTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true

func bird_hit() -> void:
	$Bird.falling = true
	stop_game()

func _on_ground_hit() -> void:
	bird_hit()

func score_increase() -> void:
	score += 1
	$CanvasLayer/AnimationPlayer.play("score_animation")
	if score > best_score:
		best_score = score
	
	var time_reduce_amount: int = score / 100
	time_reduce_amount = clamp(time_reduce_amount, 0, 1.5)
	$PipeSpawnTimer.wait_time = 3 - time_reduce_amount
	$CanvasLayer/ScoreLabel.text = str(score)

func _on_game_over_ui_restart() -> void:
	new_game()


func save_best_score() -> void:
	config.set_value("SCORE", "best_score", best_score)
	config.save("user://savegame.cfg")

func recover_best_score() -> void:
	var err = config.load("user://savegame.cfg")
	if err == OK:
		best_score = config.get_value("SCORE", "best_score")
		best_score_menu_label.text = str(best_score)


func _on_menu_ui_toggle_random_background() -> void:
	random_background_active = !random_background_active
