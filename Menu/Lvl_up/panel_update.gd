extends PanelContainer

var upgrades
signal newIndex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_upgrade_ids()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func assign_upgrade_ids():
	$MarginContainer/VBoxContainer/NameLabel.text = upgrades["upgrade"]
	#get_node("DescriptionLabel").text = upgrades["upgrade"]
	# Пытаемся загрузить иконку
	var texture = load(upgrades["icon"])
	if texture == null:
		print("Ошибка: текстура не загрузилась. Путь: ", upgrades["icon"])
	else:
		$MarginContainer/VBoxContainer/MarginContainer/TextureRect.texture = texture
		print("Текстура успешно загружена и установлена.")

func set_upgrade(upgrades):
	self.upgrades = upgrades


func _on_button_pressed() -> void:
	Upgrades.set_upgrade(upgrades["index"])
	emit_signal("newIndex")
