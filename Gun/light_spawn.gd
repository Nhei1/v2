extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/Flame_vortex.tscn")
const fireTrailType = preload("res://bullets/FireTrail.tscn")
@onready var player = get_parent()

var level = 1

var atkInterval
var dmg
var spread #in degrees
var gunNum
var penetratePwr
var is_active = true

var lvlParams = { #attackspeed, damage, spread, gunnums, pntrPower, 
	1: [1,   1,  20,  1,  1],
	2: [0.8, 2,  20,  1,  2],
	3: [0.6, 2,  20,  2,  2],
}

func _ready():
	updParams()
	set_process(true)

func _process(delta):
	fire_at_enemy_in_range()

func get_direction() -> Vector2:
	return Vector2(1, 0).rotated(rotation)

func create_bullet(start_position, target_position):
	if is_active:
		for i in range(gunNum):
			var bulletInstance = bulletType.instantiate()
			bulletInstance.set_dmg(dmg)
			if get_parent().get_movement() != Vector2.ZERO: 
				bulletInstance.add_speed(get_parent().move_speed / 2)
			bulletInstance.position = self.global_position
			var direction = get_direction()
			bulletInstance.set_direction(direction)  # Замените вызов функции set_rotation_angle на вызов функции set_direction
			var fireTrailInstance = fireTrailType.instantiate()  # Создайте новый экземпляр огненного шлейфа
			bulletInstance.add_child(fireTrailInstance)  # Добавьте огненный шлейф в качестве дочернего узла к снаряду
			fireTrailInstance.position = Vector2.ZERO
			self.add_child(bulletInstance)

func fire_at_enemy_in_range():
	var radius = 500
	var enemies_in_range = []
	var player_position = self.global_position

	# находим врагов в радиусе
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var distance = player_position.distance_to(enemy.global_position)
		if distance <= radius:
			enemies_in_range.append(enemy)

	# стреляем во врага
	if enemies_in_range:
		for enemy in enemies_in_range:
			create_bullet(player_position, enemy.global_position)

func updParams():
	if level in lvlParams:
		atkInterval = lvlParams[level][0]
		dmg = lvlParams[level][1]
		spread = lvlParams[level][2]
		gunNum = lvlParams[level][3]
		penetratePwr = lvlParams[level][4]
	else:
		print("Level not found in lvlParams")

func level_up():
	level += 1
	updParams()
