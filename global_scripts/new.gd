extends Node

# Сцена для экрана смерти или другого события
var scene_path 

# Метод, который будет вызван при смерти игрока или удалении World
func on_world_deleted():
	# Загружаем и создаем новую сцену (например, экран смерти)
	var death_scene = load(scene_path).instantiate()
	get_tree().root.add_child(death_scene)

	# Снимаем паузу, если она была установлена
	get_tree().paused = false

# Этот метод будет вызван для отслеживания удаления узла World
func track_world_deletion(world, scene):
	# Подключаемся к сигналу "tree_exited", который срабатывает при удалении узла из дерева
	world.tree_exited.connect(self._on_world_exited)
	scene_path = scene

# Обработчик удаления World
func _on_world_exited():
	print("World has been deleted, transitioning to death scene...")
	on_world_deleted()
