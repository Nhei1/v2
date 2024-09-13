extends Control

var current_upgrade_info: Dictionary
var id = 0
var gold = 0

signal update_gold

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_upgrade_details(upgrade_info: Dictionary):
	# Сохраняем данные об улучшении
	current_upgrade_info = upgrade_info
	
	# Устанавливаем текст и иконку
	$TextureRect/MarginContainer/VBoxContainer/NameLabel.text = upgrade_info["name"]
	$TextureRect/MarginContainer/VBoxContainer/DescriptionLabel.text = upgrade_info["description"]
	$TextureRect/MarginContainer/VBoxContainer/CostLabel.text = str(upgrade_info["cost"]) + " Gold"
	$TextureRect/MarginContainer/VBoxContainer/MarginContainer/TextureRect.texture = load(upgrade_info["icon"])

	# Отображаем панель (если она скрыта)
	self.visible = true
	$TextureRect/MarginContainer/VBoxContainer/Control/Button.disabled = false
	$TextureRect/MarginContainer/VBoxContainer/Control/Button.mouse_filter = Control.MOUSE_FILTER_STOP
	$TextureRect/MarginContainer/VBoxContainer/Control/Button.hide()
	$TextureRect/MarginContainer/VBoxContainer/Control/Button.show()
	
func set_id(upgrade_id):
	id = upgrade_id
	

func _on_button_pressed() -> void:
	var cost = current_upgrade_info["cost"]
	print(cost)
	var money = Saves.get_value("gold", 0)
	print(money)
	if money >= cost:
		money -= cost
		Saves.set_value("gold", money)
		apply_upgrade(current_upgrade_info["name"])
		emit_signal("update_gold")
	else:

		$TextureRect/MarginContainer/VBoxContainer/Control/Button.disabled = true
		$TextureRect/MarginContainer/VBoxContainer/Control/Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$TextureRect/MarginContainer/VBoxContainer/Control/Button.hide()
		$TextureRect/MarginContainer/VBoxContainer/Control/Button.show()


func apply_upgrade(upgrade_name: String):
	match upgrade_name:
		"Knife Boost":  # Damage Upgrade
			var damage = Saves.get_value("upgrades/knife/parameters/dmg", 0)
			damage += 1
			Saves.set_value("upgrades/knife/parameters/dmg", damage)
			print(Saves.save_data)
		"Health Boost":  # Health Upgrade
			var health = Saves.get_value("upgrades/health/value", 0)
			health += 5
			Saves.set_value("upgrades/health/value", health)
			print(Saves.save_data)
		"Speed Boost":  # Speed Upgrade
			var speed = Saves.get_value("upgrades/speed/value", 0)
			speed += 5
			Saves.set_value("upgrades/speed/value", speed)
			print(Saves.save_data)
		_:
			print("Неизвестное улучшение: ", upgrade_name)
