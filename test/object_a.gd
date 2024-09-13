extends CharacterBody2D

var mass = 2.0  # Масса объекта A
@export var restitution = 0.9
var a = 0
var b = Vector4(1.0, 1.0, 1.0, 1.0)

var base_attributes = Vector4(3.0, 1.0, 0.3, 35.0)  # [Здоровье, Атака, Защита, Скорость]

var enemy_modifiers = Vector4(1.0, 0.0, 0.0, -0.3)  # Пример модификаторов для врага
var time_modifier = Vector4(1.0, 0.0, -1.0, 1.0)  # Модификатор от времени игры
var growth_factors = Vector4(0.2, 0.15, 0.2, 0.03)  # Коэффициенты для экспоненциального роста

var modification_matrix = [
	enemy_modifiers,  
	b  
]

var final_attributes = Vector4()

func _ready():
	apply_modifiers()
	velocity = Vector2(200, 0)  # Движение вправо со скоростью 200 пикселей в секунду

func apply_modifiers():
	final_attributes = Vector4()

	# Матричное умножение
	for i in range(4):
		var result = 0.0
		for j in range(modification_matrix.size()):
			result += modification_matrix[j][i] * base_attributes[i]

		# Округляем результат до нужной точности
		final_attributes[i] = round_to_decimals(result, 0)

	print("Финальные атрибуты врага: ", final_attributes)
	print("Матрица: ", modification_matrix)

# Вспомогательная функция для округления до нужного количества знаков после запятой
func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

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
		
func plus():
	var plus = enemy_modifiers + time_modifier
	print(plus)

func calculate_time_modifier(minutes_passed: float) -> Vector4:
	var new_modifier = Vector4()
	
	for i in range(4):
		# Применяем экспоненциальный рост для каждого параметра
		new_modifier[i] = time_modifier[i] * exp(growth_factors[i] * minutes_passed)
	
	return new_modifier


func _on_timer_timeout() -> void:
	a += 1
	print(a)
	b = calculate_time_modifier(a)
	modification_matrix[1] = b
	print(b)
	apply_modifiers()
