extends Area2D

# Базовые параметры: урон, масштаб для collision_shape и sprite (не изменяются)
var baseParams = Vector3(0.1, 1.1, 1.1)

# Модификаторы: прирост урона, масштаба для collision_shape и sprite
var modifiers = Vector3(0.1, 0.18, 0.18)

# Коэффициент для экспоненциального замедления роста параметров
var lambda = 0.139

var level = 1
var bonusParams = Vector3(0, 0, 0)  # Отдельно храним накопленные бонусные параметры

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Upgrades.giveDamageAura.connect(self.set_damage)
	Upgrades.levelUpAura.connect(self.level_up)
	Upgrades.activateAura.connect(self._back_aura)
	updParams() # Инициализируем параметры на старте

# Функция для расчета бонуса с замедляющимся приростом
func get_bonus():
	# Уменьшающийся бонус на текущем уровне
	return modifiers * exp(-lambda * (level - 1))

# Обновляем параметры на основе уровня
func updParams():
	# К бонусным параметрам добавляется бонус за каждый уровень
	var bonus = get_bonus()
	bonusParams += bonus  # Накопление бонусов

	# Итоговые параметры — это сумма базовых и бонусных
	var currentParams = baseParams + bonusParams
	
	collision_shape.scale = Vector2(currentParams.y, currentParams.y)
	sprite.scale = Vector2(currentParams.z, currentParams.z)
	print("Updated params: Damage = ", currentParams.x, " Collision Scale = ", currentParams.y, " Sprite Scale = ", currentParams.z)

# Увеличиваем уровень
func level_up():
	level += 1
	updParams()

# Наносим урон объектам, попавшим в область действия ауры
func _on_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if not body.is_in_group("no aura"):
			if body.is_in_group("enemy"):
				body.call_deferred("takeDmg", baseParams.x + bonusParams.x, 0)  # Урон = базовый + бонус

# Активируем ауру
func _back_aura():
	collision_shape.disabled = false
	sprite.visible = true

func set_damage():
	baseParams.x += 0.05
	print(baseParams.x)
