extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("die")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	# Загружаем и создаем новую сцену
	var new_scene = load("res://Menu/cityMenu/city_menu.tscn").instantiate()

	# Добавляем новую сцену в корень дерева сцены
	get_tree().root.add_child(new_scene)
	# Устанавливаем новую сцену как текущую
	get_tree().set_current_scene(new_scene)
	
	self.queue_free()
