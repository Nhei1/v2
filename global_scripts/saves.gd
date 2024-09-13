extends Node

var save_file_path = "res://save_game.json"
var save_data = {}

func _ready():
	load_data()

func save_data_to_file():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()
		print("Файл сохранения создан и записан: ", save_file_path)
	else:
		print("Не удалось создать файл сохранения.")

func load_data():
	var file = FileAccess.open(save_file_path, FileAccess.READ)
	if file:
		var json_data = file.get_as_text()
		print("JSON Data: ", json_data)  # Вывод содержимого JSON-файла
		var parse_result = JSON.parse_string(json_data)
		print("Parse Result: ", parse_result)  # Вывод результата парсинга
		if typeof(parse_result) == TYPE_DICTIONARY:
			save_data = parse_result  # Загружаем данные
			print("Save Data Loaded: ", save_data)
		else:
			print("Ошибка при парсинге JSON или некорректный формат данных.")  # Выводим ошибку, если парсинг не удался
		file.close()
	else:
		# Если файла нет, инициализируем пустой словарь
		save_data = {
			"gold": 0,
			"upgrades": {
				"knife": {
					"purchases": 0,
					"parameters": {
						"atkInterval": 0,
						"dmg": 0,
						"spread": 0,
						"gunNum": 0,
						"penetratePwr": 0
					}
				},
				"health": {"purchases": 0, "value": 0},
				"speed": {"purchases": 0, "value": 0}
						}
					}
		save_data_to_file()

func set_value(key: String, value):
	var keys = key.split("/")
	var current_data = save_data
	for i in range(keys.size() - 1):
		if not keys[i] in current_data:
			current_data[keys[i]] = {}
		current_data = current_data[keys[i]]

	current_data[keys[keys.size() - 1]] = value
	save_data_to_file()

func get_value(key: String, default_value = null):
	var keys = key.split("/")
	var current_data = save_data
	for i in range(keys.size() - 1):
		if keys[i] in current_data:
			current_data = current_data[keys[i]]
		else:
			return default_value

	return current_data.get(keys[keys.size() - 1], default_value)
