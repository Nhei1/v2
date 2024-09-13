extends Control

const button = preload("res://Menu/shop/shop_button.tscn")
@onready var father = $ScrollContainer/HBoxContainer2/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Saves.load_data()
	lvl_up()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Menu/cityMenu/city_menu.tscn")
	print("EXIT!!!!!")

func lvl_up():
	var upgrades = Upgrades.assign_upgrade()  # Получаем список улучшений
	for i in range(upgrades.size()):  # Проходим по всем элементам списка
		var buttonInstantiate = button.instantiate()
		buttonInstantiate.set_upgrade_info(upgrades[i])  # Используем индекс i для доступа к улучшению
		father.add_child(buttonInstantiate)  # Добавляем кнопку в контейнер
