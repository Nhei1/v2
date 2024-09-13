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

func get_spread2deg(spread) -> float:
	var angle = deg_to_rad(randf_range(-spread / 2, spread / 2))
	return angle

func get_spread2vec(spread) -> Vector2:
	var angle = randf_range(-spread / 2, spread / 2)
	var vector = Vector2(cos(angle), sin(angle))
	return vector

func _get_spread2vec(spread) -> Vector2:
	var angle = randf_range(spread / 2 , spread )
	var vector = Vector2(cos(angle), sin(angle))
	return vector
