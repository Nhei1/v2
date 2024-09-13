extends Marker2D

@onready var intervalTimer = $AttackInterval
@onready var intervalTimerDin = $AttackIntervalDin

const bulletType = preload("res://bullets/bomb.tscn")
const bulletTypeDinamite = preload("res://bullets/dynamite/dynamite.tscn")
@onready var player = get_parent()

signal bullet_created

var levelBomb = 1
var levelDin = 1
var is_active_bomb = false
var is_active_dinamite = false

# Базовые параметры для Bomb и Dinamite (atkInterval, gunNum, damage)
var baseParamsBomb = [4.0, 0.7, 0.4]  # (атака, количество пуль, урон)
var baseParamsDin = [5.0, 0.7, 1]   # (атака, количество пуль, урон)

# Модификаторы для Bomb и Dinamite (atkInterval, gunNum, damage)
var modifiersBomb = [-0.4, 0.6, 1]  # (уменьшение атаки, увеличение количества пуль, увеличение урона)
var modifiersDin = [-0.5, 0.4, 3]   # (уменьшение атаки, увеличение количества пуль, увеличение урона)

# Коэффициент для экспоненциального прироста
var lambda = 0.139

# Бонусные параметры для Bomb и Dinamite
var bonusParamsBomb = [0.0, 0, 0]
var bonusParamsDin = [0.0, 0, 0]

# Текущие значения параметров
var atkIntervalBomb
var gunNumBomb
var dmgBomb
var atkIntervalDin
var gunNumDin
var dmgDin

func _ready():
	updParamsBomb()
	updParamsDin()
	Upgrades.giveDamageBomb.connect(self.set_damageBomb)
	Upgrades.giveDamageDin.connect(self.set_damageDin)
	Upgrades.levelUpBomb.connect(self.level_upBomb)
	Upgrades.activateBomb.connect(self.activeBomb)
	Upgrades.levelUpDin.connect(self.level_upDin)
	Upgrades.activateDin.connect(self.activeDin)

func _process(delta):
	fireBomb()
	fireDin()

# Функция для расчета бонуса на основе уровня
func get_bonus(level, modifiers):
	var bonus = []
	for i in range(modifiers.size()):
		bonus.append(modifiers[i] * exp(-lambda * (level - 1)))
	return bonus

# Обновляем параметры Bomb
func updParamsBomb():
	var bonus = get_bonus(levelBomb, modifiersBomb)
	for i in range(baseParamsBomb.size()):
		bonusParamsBomb[i] += bonus[i]
	atkIntervalBomb = round_to_decimals(baseParamsBomb[0] + bonusParamsBomb[0], 2)
	if atkIntervalBomb <= 1.0:
		atkIntervalBomb = 1.0
	gunNumBomb = round_to_decimals(baseParamsBomb[1] + bonusParamsBomb[1], 0)
	dmgBomb = round_to_decimals(baseParamsBomb[2] + bonusParamsBomb[2], 1)

# Обновляем параметры Dinamite
func updParamsDin():
	var bonus = get_bonus(levelDin, modifiersDin)
	for i in range(baseParamsDin.size()):
		bonusParamsDin[i] += bonus[i]
	atkIntervalDin = round_to_decimals(baseParamsDin[0] + bonusParamsDin[0], 2)
	if atkIntervalDin <= 1.5:
		atkIntervalDin = 1.5
	gunNumDin = round_to_decimals(baseParamsDin[1] + bonusParamsDin[1], 0)
	dmgDin = round_to_decimals(baseParamsDin[2] + bonusParamsDin[2], 1)

# Функция округления значений
func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

# Создание бомб
func create_bomb():
	if is_active_bomb:
		for i in range(gunNumBomb):
			var bulletInstance = bulletType.instantiate()
			bulletInstance.set_dmg(dmgBomb)  # Устанавливаем урон для пули
			bulletInstance.position = self.global_position
			self.add_child(bulletInstance)
			
			if i < gunNumBomb - 1:
				await get_tree().create_timer(0.3).timeout  # Ждем 0.1 секунды перед созданием следующего

# Создание динамита
func create_dinamite():
	if is_active_dinamite:
		for i in range(gunNumDin):
			var bulletInstanceDin = bulletTypeDinamite.instantiate()
			bulletInstanceDin.set_dmg(dmgDin)  # Устанавливаем урон для динамита
			bulletInstanceDin.position = self.global_position
			self.add_child(bulletInstanceDin)
			
			if i < gunNumDin - 1:
				await get_tree().create_timer(0.3).timeout  # Ждем 0.1 секунды перед созданием следующего

# Запуск бомб
func fireBomb():
	if intervalTimer.is_stopped():
		create_bomb()
		emit_signal("bullet_created")
		intervalTimer.start(atkIntervalBomb)

# Запуск динамита
func fireDin():
	if intervalTimerDin.is_stopped():
		create_dinamite()
		emit_signal("bullet_created")
		intervalTimerDin.start(atkIntervalDin)

# Уровень бомбы повышен
func level_upBomb():
	levelBomb += 1
	updParamsBomb()

# Уровень динамита повышен
func level_upDin():
	levelDin += 1
	updParamsDin()

# Активация бомбы
func activeBomb():
	self.is_active_bomb = true

# Активация динамита
func activeDin():
	self.is_active_dinamite = true

func set_damageBomb():
	baseParamsBomb[0] += 0.5

func set_damageDin():
	baseParamsDin[0] += 2.0
