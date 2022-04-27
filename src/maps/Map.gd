extends Node2D

var map_size

onready var player_health_label = $CanvasLayer/Control/PlayerHealth
onready var enemy_health_label = $CanvasLayer/Control/EnemyHealth
onready var score_label = $CanvasLayer/Control/Score
onready var restart_label = $CanvasLayer/Control/Label

export (PackedScene) var Player
export (PackedScene) var Enemy
export (PackedScene) var PlayerCamera
var player
var enemy
var camera
var is_start = false setget set_is_start
var score = 0 setget set_score

func set_score(_score):
	print(_score)
	score = _score
	score_label.text = "Score: "+String(score)

func _ready():
	randomize()
	var cell_count = $TileMap.get_used_rect().size
	var cell_size = $TileMap.cell_size
	map_size = cell_count*cell_size
	camera = PlayerCamera.instance()
	camera.limit_bottom = map_size.y
	camera.limit_right = map_size.x
	camera.make_current()
	var window_size = OS.window_size
	var max_zoom_ratio = map_size/window_size
	print(map_size)
	print(window_size)
	print(max_zoom_ratio)
	camera.max_zoom_ratio = min(max_zoom_ratio.x, max_zoom_ratio.y)
	set_is_start(true)
	
func _on_shoot(bullet):
	add_child(bullet)

func rander_transform():
	return Transform2D(rand_range(-2*PI, 2*PI), Vector2(rand_range(0, map_size.x), rand_range(0, map_size.y)))

func new_player():
	player = Player.instance()
	player.transform = rander_transform()
	player.add_child(camera)
	player.connect("shoot", self, "_on_shoot")
	player.connect("hit", self, "_on_Player_hit")
	player.connect("destoried", self, "_on_Player_destoried")
	add_child(player)
	player_health_label.text = "Player Health: "+String(player.health)
	
func new_enemy():
	enemy = Enemy.instance()
	enemy.transform = rander_transform()
	enemy.connect("shoot", self, "_on_shoot")
	enemy.connect("hit", self, "_on_Enemy_hit")
	enemy.connect("destoried", self, "_on_Enemy_destoried")
	add_child(enemy)
	enemy_health_label.text = "Enemy Health: "+String(enemy.health)

func set_is_start(_is_start):
	is_start = _is_start
	restart_label.visible = !is_start
	if is_start:
		new_player()
		new_enemy()
	else:
		player.queue_free()
		player.remove_child(camera)
		enemy.queue_free()
	
func _on_Player_destoried():
	set_is_start(false)

func _on_Player_hit():
	player_health_label.text = "Player Health: "+String(player.health)

func _on_Enemy_destoried():
	set_score(score+1)
	enemy.queue_free()
	new_enemy()

func _on_Enemy_hit():
	enemy_health_label.text = "Enemy Health: "+String(enemy.health)

func _on_Button_pressed():
	set_is_start(true)
