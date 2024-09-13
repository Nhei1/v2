extends PanelContainer

@export var upgrade_id: int = -1  # ID улучшения, назначается программно
var upgrade_info: Dictionary
@onready var details_panel = get_node("/root/Shop/Control")

func set_upgrade_info(upgrade_info: Dictionary):
	print("Устанавливаем информацию для улучшения: ", upgrade_info["name"])
	
	# Устанавливаем текст и иконку на основе переданных данных
	$MarginContainer2/VBoxContainer/NameLabel.text = upgrade_info["name"]
	$MarginContainer2/VBoxContainer/DescriptionLabel.text = upgrade_info["description"]
	$MarginContainer2/VBoxContainer/CostLabel.text = str(upgrade_info["cost"]) + " Gold"
	# Пытаемся загрузить иконку
	var texture = load(upgrade_info["icon"])
	if texture == null:
		print("Ошибка: текстура не загрузилась. Путь: ", upgrade_info["icon"])
	else:
		$MarginContainer2/VBoxContainer/MarginContainer/TextureRect.texture = texture
		print("Текстура успешно загружена и установлена.")

	# Сохраняем upgrade_info, если нужно использовать его позже
	self.upgrade_info = upgrade_info
	print(upgrade_id)


func _on_button_pressed() -> void:
	details_panel.set_upgrade_details(upgrade_info)
	details_panel.set_id(upgrade_id)
