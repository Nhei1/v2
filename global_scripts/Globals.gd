extends Node

@onready var player = null
@onready var screenSize: Vector2 = get_viewport().size
var playerPosition: Vector2 = Vector2.ZERO

func _ready():
	update_screen_size()

func update_screen_size():
	screenSize = get_viewport().size
	print(screenSize)

func get_screen_size() -> Vector2:
	return screenSize

func get_screen_diagonale() -> float:
	return sqrt((screenSize.x)*(screenSize.x) + (screenSize.y)*(screenSize.y))
