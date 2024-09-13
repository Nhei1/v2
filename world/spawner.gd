extends Node

@export var enemies: Array[PackedScene] = []
@export var spawnArea = 250
@onready var timer = $Timer
@onready var changeEnemyTimer = $Timer2
@onready var gameTimer = $Timer3
@onready var Player = get_node("/root/World/Player")
var health_values = [3, 4, 5, 7, 10]
var health_index = 0
var basic_modifier = Vector4(1.0, 1.0, 1.0, 1.0)  # Модификатор от времени игры
var growth_factors = Vector4(0.2, 0.15, 0.1, 0.03)  # Коэффициенты для экспоненциального роста
var time_modifier = Vector4(1.0, 1.0, 1.0, 1.0)

var spawnTime = 2.0  # Начальный интервал спавна
var changeEnemyTime = 60
var current_enemy = 0
var maxEnemies = 15  # Начальное ограничение количества врагов
var gameTime = 0.0  # Время игры в секундах

signal enemy_spawned(enemy_index)

func _ready():
	if timer:
		timer.set_wait_time(spawnTime)
		timer.timeout.connect(self._on_Timer_timeout)
		timer.start()
		print("Timer started with wait time: ", spawnTime)
	else:
		print("Error: Timer node not found.")
		
	if changeEnemyTimer:
		changeEnemyTimer.set_wait_time(changeEnemyTime)
		changeEnemyTimer.timeout.connect(self._on_timer_2_timeout)
		changeEnemyTimer.start()
		print("ChangeEnemyTimer started with wait time: ", changeEnemyTime)
	else:
		print("Error: ChangeEnemyTimer node not found.")
	
	if gameTimer:
		gameTimer.set_wait_time(60.0)  # Обновляем раз в минуту
		gameTimer.timeout.connect(self._on_game_timer_timeout)
		gameTimer.start()
		print("GameTimer started with wait time: 60.0")
	else:
		print("Error: GameTimer node not found.")

func spawn(spawn_position = Vector2.ZERO):
	var enemy_count_before = get_tree().get_nodes_in_group("enemies").size()

	if enemy_count_before >= maxEnemies:
		return

	var enemy = enemies[current_enemy]
	var instance = enemy.instantiate()

	if spawn_position == Vector2.ZERO:
		spawn_position = generate_spawn_position(Globals.get_screen_size())

	instance.position = spawn_position
	instance.connect("despawned", self._on_enemy_despawned)
	instance.enemy_died.connect(get_node("/root/World").on_enemy_died)
	instance.set_time_modifier(time_modifier)

	self.add_child(instance)
	instance.add_to_group("enemies")

	emit_signal("enemy_spawned", current_enemy)

func generate_opposite_spawn_position(current_spawn_pos: Vector2, screenSize: Vector2, player_pos: Vector2) -> Vector2:
	# Рассчитываем увеличенную диагональ с добавлением 300
	var extended_diagonale = Globals.get_screen_diagonale() + 1200

	# Определяем соотношение сторон экрана
	var aspect_ratio = screenSize.x / screenSize.y

	# Рассчитываем масштабированные размеры экрана, чтобы учесть соотношение сторон
	var scaled_width = extended_diagonale * aspect_ratio / sqrt(aspect_ratio * aspect_ratio + 1)
	var scaled_height = extended_diagonale / sqrt(aspect_ratio * aspect_ratio + 1)

	# Определяем угол от игрока до текущей позиции спавна
	var angle_to_spawn = player_pos.angle_to_point(current_spawn_pos)

	# Рассчитываем противоположный угол
	var opposite_angle = angle_to_spawn + PI

	# Вычисляем координаты новой позиции спавна, учитывая масштабированные размеры экрана
	var opposite_spawn_pos = Vector2()
	opposite_spawn_pos.x = player_pos.x + (scaled_width / 2) * cos(opposite_angle)
	opposite_spawn_pos.y = player_pos.y + (scaled_height / 2) * sin(opposite_angle)

	return opposite_spawn_pos

func generate_spawn_position(screenSize: Vector2) -> Vector2:
	var side = randi() % 4
	var spawn_pos: Vector2
	var player_pos = Player.getGlobalPosition()
	var buffer = 50

	match side:
		0:
			spawn_pos = Vector2(randf_range(0, screenSize.x), player_pos.y - screenSize.y - buffer)
		1:
			spawn_pos = Vector2(player_pos.x + screenSize.x + buffer, randf_range(0, screenSize.y))
		2:
			spawn_pos = Vector2(randf_range(0, screenSize.x), player_pos.y + screenSize.y + buffer)
		3:
			spawn_pos = Vector2(player_pos.x - screenSize.x - buffer, randf_range(0, screenSize.y))

	return spawn_pos

func _on_enemy_despawned(old_position):
	var screenSize = Globals.get_screen_size()
	var player_pos = Player.getGlobalPosition()
	var opposite_spawn_pos = generate_opposite_spawn_position(old_position, screenSize, player_pos)
	spawn(opposite_spawn_pos)

func _on_Timer_timeout():
	spawn()

func set_enemies(value: Array[PackedScene]):
	enemies = value

func _on_timer_2_timeout():
	current_enemy = (current_enemy + 1) % enemies.size()
	

func _on_game_timer_timeout():
	gameTime += 60.0  # Увеличиваем время игры на 60 секунд
	var minutes_passed = gameTime / 60.0
	time_modifier = calculate_time_modifier(minutes_passed)
	# Обновляем интервал спавна (уменьшаем от 2.0 до 0.5)
	spawnTime = lerp(2.0, 0.5, min(minutes_passed / 20.0, 1.0))
	if timer:
		timer.set_wait_time(spawnTime)
		timer.start()
	
	# Обновляем ограничение количества врагов (увеличиваем от 15 до 100)
	maxEnemies = int(lerp(15, 100, min(minutes_passed / 20.0, 1.0)))

func calculate_time_modifier(minutes_passed: float) -> Vector4:
	var new_modifier = Vector4()
	
	for i in range(4):
		# Применяем экспоненциальный рост для каждого параметра
		new_modifier[i] = basic_modifier[i] * exp(growth_factors[i] * minutes_passed)
	
	return new_modifier
