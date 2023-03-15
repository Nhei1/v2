extends Node

@export var enemy: PackedScene
@export var spawnArea = 250
@onready var timer = $Timer
@onready var Player = get_node("/root/World/Player")

var spawnTime = 0.5

func _ready():
	timer.set_wait_time(spawnTime)
	timer.start()

func spawn():
	var instance = enemy.instantiate()
	var screenSize = Globals.get_screen_size()
	instance.position = (Player.getPosition() + Vector2(Globals.get_screen_diagonale() / 2, 0)).rotated(God.get_spawn_angle())
	self.add_child(instance)

func _on_Timer_timeout():
	spawn()
