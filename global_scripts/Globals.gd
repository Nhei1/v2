extends Node

@onready var player = get_node("/root/World/Player")

@onready var screenSize: Vector2 = get_viewport().size
var playerPosition: Vector2

func _ready():
	update_screen_size()

func _process(delta):
	update_player_pos()


#Updaters for global vars
func update_screen_size():
	screenSize = get_viewport().size

func update_player_pos():
	playerPosition = player.getPosition()


#Getters
func get_screen_size() -> Vector2:
	return screenSize

func get_player_pos() -> Vector2:
	return playerPosition

func get_screen_diagonale() -> float:
	return sqrt((screenSize.x)*(screenSize.x) + (screenSize.y)*(screenSize.y))
