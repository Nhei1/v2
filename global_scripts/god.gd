extends Node

var god = RandomNumberGenerator.new()

func _ready():
	god.randomize()

func get_integer(a, b) -> int:
	return god.randi_range(a, b)

func get_float(precision) -> float:
	return snapped(god.randf(), precision)

func get_spawn_angle():
	return god.randf_range(0, 2*PI)

