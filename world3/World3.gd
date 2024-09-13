extends Node

@onready var _player = $Player
@onready var _label = $UI/Interface/Label
@onready var TimerLabel = $UI/Interface/GameTimerLabel
@onready var EnemyLabel = $UI/Interface/EnemyInfo
@onready var _timer = Timer.new()
@onready var goldLabel = $UI/Interface/TextureRect/Label2
@onready var plDie = ("res://die_Screen/die_Screen.tscn")
@onready var plWin = ("res://win_Screen/win_Screen.tscn")
#onready var _bar = $Interface/ExperienseBar
var playerPosition: Vector2 = Vector2.ZERO

var grid_size = Vector2(10080, 3888) # Размер одной копии фона
var bg_list = [] # Список всех созданных фонов
var remove_distance = 1.5

var game_time = 0
var game_timer = Timer.new()
var gold = 0

signal enemy_died

func _ready():
	game_timer.set_wait_time(1) # Обновление каждую секунду
	game_timer.autostart = true
	game_timer.timeout.connect(self._on_game_timer_timeout)
	add_child(game_timer)

	var initial_bg = $Background
	bg_list.append(initial_bg)
	_player.killed.connect(self.playerDie)
	_player.lvl_up.connect(self.pause)
	Upgrades.lvl_up_done.connect(self.unpause)
	get_node("/root/World/spawner3").enemy_spawned.connect(self._on_enemy_spawned)
	update_exp()

func _process(delta):
	update_player_pos()
	check_and_create_background(playerPosition)
	remove_far_backgrounds(playerPosition)

	if Input.is_action_just_pressed("ui_accept"):
		_player._on_first_update_timer_timeout()
		#_player.gain_experiense(1)
		update_exp()

func update_exp():
	_label.update_text(_player.level, _player.experiense, _player.experiense_required)

func _on_game_timer_timeout():
	game_time += 1 # Увеличиваем время игры на одну секунду
	update_game_timer_label() # Обновляем текст метки с таймером
	update_exp()
	if (game_time / 60) == 15:
		playerWin()

func pause(s=1):
	get_tree().paused = bool(s)

func unpause():
	pause(0)

func playerDie():
	# Сообщаем глобальному GameManager, что World будет удалён
	New.track_world_deletion(self, plDie)

	for child in get_children():
		child.queue_free()  # Удаляем все дочерние узлы, кроме анимации смерти
	
	# Удаляем текущий World после анимации смерти
	self.queue_free()

func playerWin():
	# Сообщаем глобальному GameManager, что World будет удалён
	New.track_world_deletion(self, plWin)

	for child in get_children():
		child.queue_free()  # Удаляем все дочерние узлы, кроме анимации смерти
	
	# Удаляем текущий World после анимации смерти
	self.queue_free()

func update_game_timer_label():
	var minutes = int(game_time) / 60
	var seconds = int(game_time) % 60
	TimerLabel.update_timer(minutes, seconds)

func _on_enemy_spawned(enemy_index):
	# Обновите текст на экране с информацией о враге
	EnemyLabel.update_enemy_info(enemy_index)

func on_enemy_died():
	var base_gold = 5
	
	# Время игры в минутах
	var game_time_minutes = game_time / 60
	
	# Параметры логистической функции
	var L = 33  # Максимальный бонус золота
	var k = 0.5  # Коэффициент роста
	var t0 = 6  # Время, после которого начинается резкий рост золота
	
	# Логистическая функция для расчета бонуса
	var bonus_gold = L / (1 + exp(-k * (game_time_minutes - t0)))
	
	# Общая награда
	var total_gold = base_gold + int(bonus_gold)
	gold += total_gold
	goldLabel.update_gold(gold)
	
	print("Получено золото: ", total_gold, " Всего золота: ", gold)

#Работа с фонами
func check_and_create_background(player_pos):
	# Получаем границы текущего фона
	for bg in bg_list:
		var bg_pos = bg.global_position
		var bg_rect = Rect2(bg_pos - grid_size/2, grid_size)

		# Проверяем, находится ли игрок вблизи границ
		if not bg_rect.has_point(player_pos):
			continue

		# Создаем новые копии фона
		for x in range(-1, 2):
			for y in range(-1, 2):
				var new_pos = bg_pos + Vector2(x * grid_size.x, y * grid_size.y)
				if not is_bg_at_position(new_pos):
					var new_bg = bg.duplicate()
					new_bg.position = new_pos
					get_parent().add_child(new_bg)
					bg_list.append(new_bg)

func is_bg_at_position(position):
	for bg in bg_list:
		if bg.position == position:
			return true
	return false

func remove_far_backgrounds(player_pos):
	for bg in bg_list:
		var distance = player_pos.distance_to(bg.global_position)
		if distance > grid_size.length() * remove_distance:
			bg_list.erase(bg)
			bg.queue_free()

func update_player_pos():
	if is_instance_valid(_player):
		playerPosition = _player.global_position

func get_player_pos() -> Vector2:
	return playerPosition
