extends CharacterBody2D

var mass = 5.0  # Масса объекта A
@export var restitution = 0.2

func _ready():
	# Устанавливаем начальное направление и скорость
	velocity = Vector2(-150, 0)  # Движение вправо со скоростью 200 пикселей в секунду


func _process(delta):
	# Обновляем позицию объекта с учетом скорости
	position += velocity * delta

	# Проверяем столкновение с краями экрана
	_check_screen_collision()

	# Двигаем объект и проверяем столкновения с другими объектами
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		_handle_collision(collision_info)

func _check_screen_collision():
	var screen_size = get_viewport_rect().size

	# Левая граница
	if position.x < 0:
		position.x = 0  # Исправляем позицию
		velocity.x = -velocity.x * restitution  # Отражаем скорость по X с учетом потерь
	
	# Правая граница
	if position.x > screen_size.x:
		position.x = screen_size.x  # Исправляем позицию
		velocity.x = -velocity.x * restitution  # Отражаем скорость по X с учетом потерь

	# Верхняя граница
	if position.y < 0:
		position.y = 0  # Исправляем позицию
		velocity.y = -velocity.y * restitution  # Отражаем скорость по Y с учетом потерь
	
	# Нижняя граница
	if position.y > screen_size.y:
		position.y = screen_size.y  # Исправляем позицию
		velocity.y = -velocity.y * restitution  # Отражаем скорость по Y с учетом потерь

func _handle_collision(collision_info):
	var other = collision_info.get_collider() as CharacterBody2D
	if other:
		# Получаем нормаль к поверхности столкновения
		var normal = collision_info.get_normal()

		# Получаем относительную скорость
		var relative_velocity = other.velocity - velocity

		# Проецируем относительную скорость на нормаль
		var vel_normal = relative_velocity.dot(normal)

		# Закон сохранения импульса для упругого столкновения с учетом коэффициента восстановления
		var total_mass = mass + other.mass
		var impulse = 2 * vel_normal / total_mass

		# Обновляем скорости объектов после столкновения
		velocity += impulse * other.mass * normal * restitution
		other.velocity -= impulse * mass * normal * restitution
