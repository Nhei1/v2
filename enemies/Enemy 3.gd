extends CharacterBody2D

var player = null
var animPlayer = null
@export var despawn_margin = 1500  # Отступ от границ экрана для диспавна
@onready var screenSize = Globals.get_screen_size()
var moveSpeed = 40
var slowdown = 0
var steps = 0
var health = 3
var defence = 1
var damage_amount = 1 # количество урона, которое будет наноситься
var damage_interval = 0.15 # интервал нанесения урона в секундах
var damage_timer = null
var magnet_chance: float = 0.05
var base_attributes = Vector4(health, damage_amount, defence, moveSpeed)  # [Здоровье, Атака, Защита, Скорость]
var enemy_modifiers = Vector4(1.0, 2.0, 0.0, 0.2)  # Пример модификаторов для врага
var time_modifier = Vector4(1.0, 1.0, 1.0, 1.0)  # Модификатор от времени игры

var final_attributes = Vector4()

var modification_matrix = [
	enemy_modifiers,  
	time_modifier  
]

var exp_shard_scene = preload("res://xp/XP.tscn")
var magnet_scene = preload("res://xp/magnet.tscn")

signal despawned(old_position)
signal enemy_died

func _ready():
	modification_matrix[1] = time_modifier
	apply_modifiers()
	apply_parameters()
	add_to_group("enemy")
	add_to_group("enemies")
	player = get_node("/root/World/Player")
	animPlayer = $AnimPlayer

func _physics_process(delta):
	check_distance_to_player_and_despawn()
	var to_player = (player.position - position).normalized()
	velocity = to_player * (moveSpeed - slowdown)
	move_and_slide()

func dealDMG():
	return damage_amount

func takeDmg(damage, ignoreDef):
	if defence < damage:
		health -= (damage - getDef(defence, ignoreDef))
		print(getDef(defence, ignoreDef))
	if animPlayer.current_animation == "takeDmg":
		animPlayer.stop()
	animPlayer.play("takeDmg")
	if health <= 0:
		die()

func getDef(defence, ignoreDef):
	var def = defence * ignoreDef
	if def == 0:
		return 0
	else:
		return (def / 100)

func _on_damage_timer_timeout() -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			print("Урон игроку", damage_amount)
			body.damage(damage_amount)

func die():
	if randi() % 100 < magnet_chance * 100:
		var magnet = magnet_scene.instantiate()
		magnet.position = position
		get_parent().add_child(magnet)
	else:
		var shard = exp_shard_scene.instantiate()
		shard.position = position
		get_parent().add_child(shard)
	emit_signal("enemy_died")
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$DeathParticles.play()

func _on_timer_timeout():
	self.queue_free()

func check_distance_to_player_and_despawn():
	var player_pos = player.getGlobalPosition()
	
	# Вычисляем увеличенную диагональ с добавлением поля для диспавна
	var extended_diagonale = Globals.get_screen_diagonale() + despawn_margin

	# Определяем соотношение сторон экрана
	var aspect_ratio = Globals.get_screen_size().x / Globals.get_screen_size().y

	# Рассчитываем масштабированные размеры экрана с учетом увеличенной диагонали
	var scaled_width = extended_diagonale * aspect_ratio / sqrt(aspect_ratio * aspect_ratio + 1)
	var scaled_height = extended_diagonale / sqrt(aspect_ratio * aspect_ratio + 1)

	# Вычисляем границы увеличенной области для проверки диспавна
	var extended_area_top_left = player_pos - Vector2(scaled_width, scaled_height) / 2
	var extended_area_bottom_right = player_pos + Vector2(scaled_width, scaled_height) / 2

	# Проверка выхода за границы
	if position.x < extended_area_top_left.x or position.x > extended_area_bottom_right.x or position.y < extended_area_top_left.y or position.y > extended_area_bottom_right.y:
		despawn()

func despawn():
	emit_signal("despawned", global_position)
	queue_free()

func set_health(health):
	self.health = health

func set_time_modifier(modifier: Vector4):
	self.time_modifier = modifier  # сохраняем модификатор

func set_slowdown(slow, step):
	if slow > 0 and step > 0:
		if slow > steps:
			steps += step
		self.slowdown = (moveSpeed * steps) / 100
		$SlowTimer.start()
	else:
		pass


func _on_slow_timer_timeout() -> void:
	self.slowdown = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DamageTimer.start()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$DamageTimer.stop()

func apply_modifiers():
	final_attributes = Vector4()

	# Матричное умножение
	for i in range(4):
		var result = 0.0
		for j in range(modification_matrix.size()):
			result += modification_matrix[j][i] * base_attributes[i]

		# Округляем результат до нужной точности
		final_attributes[i] = round_to_decimals(result, 0)

	print("Финальные атрибуты врага: ", final_attributes)

func apply_parameters():
	health = final_attributes[0]
	damage_amount = final_attributes[1]
	defence = final_attributes[2]
	moveSpeed = final_attributes[3]
	print(health, damage_amount, defence, moveSpeed)

# Вспомогательная функция для округления до нужного количества знаков после запятой
func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale
