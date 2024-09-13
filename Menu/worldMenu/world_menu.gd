extends Control

@onready var color_rect2 = $MarginContainer/VBoxContainer/TextureRect/ColorRect2
@onready var color_rect = $MarginContainer/VBoxContainer/TextureRect/ColorRect
@onready var color_rect_rain = $MarginContainer/VBoxContainer/TextureRect/ColorRectRain
@onready var color_rect_battle = $MarginContainer/VBoxContainer/TextureRect/ColorRectBattle
@onready var texture_rect = $MarginContainer/VBoxContainer/TextureRect
@onready var animation_player = $AnimationPlayer

var maps = [
	{"name": "Map1", "texture": preload("res://Menu/worldMenu/World1.png"), "effect": "default"},
	{"name": "Map2", "texture": preload("res://Menu/worldMenu/World2.png"), "effect": "rain"},
	{"name": "Map3", "texture": preload("res://Menu/worldMenu/World3.png"), "effect": "battle"}
]

var current_map_index = 0


func _ready() -> void:
	if color_rect2 != null:
		if color_rect2.material == null:
			print("Материал не назначен на ColorRect2.")
			color_rect2.material = ShaderMaterial.new()  # Создание нового ShaderMaterial, если его нет
		else:
			print("Материал найден и готов к использованию.")
	else:
		print("ColorRect2 не найден.")

	update_texture_rect()


func update_texture_rect() -> void:
	# Обновляем изображение в TextureRect
	texture_rect.texture = maps[current_map_index]["texture"]
	# Обновляем эффекты в зависимости от выбранной карты
	update_effects(maps[current_map_index]["effect"])

func update_effects(effect: String) -> void:
	if effect == "rain":
		color_rect.visible = false
		color_rect_rain.visible = true
		color_rect_battle.visible = false
	elif effect == "battle":
		color_rect.visible = false
		color_rect_battle.visible = true
		color_rect_rain.visible = false
	else:
		color_rect.visible = true
		color_rect_battle.visible = false
		color_rect_rain.visible = false

func _process(delta: float) -> void:
	pass

func _on_button_play_pressed() -> void:
	# Логика запуска уровня с выбранной картой
	match current_map_index:
		0:
			print("Запуск карты: World")
			get_tree().change_scene_to_file("res://world/World.tscn")
		1:
			print("Запуск карты: World2")
			get_tree().change_scene_to_file("res://world2/World2.tscn")
		2:
			print("Запуск карты: World3")
			get_tree().change_scene_to_file("res://world3/World3.tscn")
		_:
			print("Неизвестный индекс карты: " + str(current_map_index))

func _on_button_left_pressed() -> void:
	if color_rect2 and color_rect2.material:
		# Запускаем анимацию, чтобы затемнить экран
		animation_player.play("fade_out")
		await animation_player.animation_finished

		# Изменяем изображение
		current_map_index = (current_map_index - 1 + maps.size()) % maps.size()
		update_texture_rect()

		# Запускаем анимацию для восстановления затемнения
		animation_player.play("fade_in")
	else:
		print("ColorRect2 или его материал не найден.")

func _on_button_right_pressed() -> void:
	if color_rect2 and color_rect2.material:
		# Запускаем анимацию, чтобы затемнить экран
		animation_player.play("fade_out")
		await animation_player.animation_finished

		# Изменяем изображение
		current_map_index = (current_map_index + 1) % maps.size()
		update_texture_rect()

		# Запускаем анимацию для восстановления затемнения
		animation_player.play("fade_in")
	else:
		print("ColorRect2 или его материал не найден.")

func _on_timer_timeout() -> void:
	pass # Replace with function body.
