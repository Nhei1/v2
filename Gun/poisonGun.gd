extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/poison.tscn")
@onready var player = get_parent()

signal bullet_created

var level = 1
var is_active = false

# Базовые параметры для Poison (atkInterval, gunNum, damage)
var baseParams = [4.0, 0.6, 0]  # (атака, количество пуль, урон)

# Модификаторы для Poison (atkInterval, gunNum, damage)
var modifiers = [-0.3, 0.5, 0.15]  # (уменьшение интервала атаки, увеличение количества пуль, увеличение урона)

# Коэффициент для экспоненциального прироста
var lambda = 0.139

# Бонусные параметры
var bonusParams = [0.0, 0, 0]

# Текущие значения параметров
var atkInterval
var gunNum
var damage

func _ready():
	updParams()
	Upgrades.giveDamagePoison.connect(self.set_damage)
	Upgrades.levelUpPoison.connect(self.level_up)
	Upgrades.activatePoison.connect(self.active)

func _process(delta):
	fire()


# Функция для расчета бонуса на основе уровня
func get_bonus(level, modifiers):
	var bonus = []
	for i in range(modifiers.size()):
		bonus.append(modifiers[i] * exp(-lambda * (level - 1)))
	return bonus

# Обновляем параметры Poison
func updParams():
	var bonus = get_bonus(level, modifiers)
	for i in range(baseParams.size()):
		bonusParams[i] += bonus[i]
	
	atkInterval = round_to_decimals(baseParams[0] + bonusParams[0], 2)
	if atkInterval <= 1.0:
		atkInterval = 1.0  # Устанавливаем минимальный предел для atkInterval
	gunNum = round_to_decimals(baseParams[1] + bonusParams[1], 0)
	damage = round_to_decimals(baseParams[2] + bonusParams[2], 1)

# Функция округления значений
func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

# Создание пули
func create_bullet():
	if is_active:
		for i in range(gunNum):
			var bulletInstance = bulletType.instantiate()
			bulletInstance.set_dmg(damage)  # Устанавливаем урон для каждой пули
			bulletInstance.position = self.global_position
			self.add_child(bulletInstance)
			if i < gunNum - 1:
				await get_tree().create_timer(0.3).timeout  # Ждем 0.1 секунды перед созданием следующего ножа


# Запуск атаки
func fire():
	if intervalTimer.is_stopped():
		create_bullet()
		emit_signal("bullet_created")
		intervalTimer.start(atkInterval)

# Повышение уровня
func level_up():
	level += 1
	updParams()

# Активация атаки
func active():
	self.is_active = true

func set_damage():
	baseParams[2] += 0.05
