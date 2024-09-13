extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/knive.tscn")
@onready var player = get_parent()

signal bullet_created

var level = 1
var is_active = false
var last_spread_angle = 0.0

# Базовые параметры (atkInterval, dmg, spread, gunNum, penetratePwr)
var baseParams = [1.4, 0, 9, 0.7, 1]  # Порядок: [atkInterval, dmg, spread, gunNum, penetratePwr]

# Модификаторы, которые будут увеличиваться с каждым уровнем
var modifiers = [-0.1, 1.5, 3, 0.6, 1]  # Порядок: [atkInterval, dmg, spread, gunNum, penetratePwr]

# Коэффициент затухания для экспоненциальной функции
var lambda = 0.139

# Бонусные параметры, которые будут суммироваться с базовыми
var bonusParams = [0, 0, 0, 0, 0]

# Текущие значения параметров
var atkInterval
var dmg
var spread  # in degrees
var gunNum
var penetratePwr

func _ready():
	updParams()
	Upgrades.giveDamageKnife.connect(self.set_damage)
	Upgrades.levelUpKnife.connect(self.level_up)
	Upgrades.activateKnife.connect(self.active)

func _process(delta):
	if is_active:
		fire()

# Функция для расчета бонуса на основе экспоненциального затухания
func get_bonus(level):
	var bonus = []
	for i in range(baseParams.size()):
		bonus.append(modifiers[i] * exp(-lambda * (level - 1)))
	return bonus

# Функция для обновления параметров
func updParams():
	# Рассчитываем бонусы и суммируем с базовыми параметрами
	var bonus = get_bonus(level)
	for i in range(baseParams.size()):
		bonusParams[i] += bonus[i]

	atkInterval = round_to_decimals(baseParams[0] + bonusParams[0], 2)
	if atkInterval <= 0.55:
		atkInterval = 0.55  # Минимальный предел для atkInterval
	dmg = round_to_decimals(baseParams[1] + bonusParams[1], 1)
	spread = round_to_decimals(baseParams[2] + bonusParams[2], 0)
	gunNum = round_to_decimals(baseParams[3] + bonusParams[3], 0)
	penetratePwr = round_to_decimals(baseParams[4] + bonusParams[4], 0)
	
	print("Level:", level, " Params: atkInterval=", atkInterval, " dmg=", dmg, " spread=", spread, " gunNum=", gunNum, " penetratePwr=", penetratePwr)

# Функция для округления значений
func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

func create_bullet():
	var base_direction = player.get_direction()
	var angle_step = spread / float(gunNum - 1)
	var current_angle = -spread / 2

	for i in range(gunNum):
		var bulletInstance = bulletType.instantiate()
		bulletInstance.set_dmg(dmg)
		if level >= 4:
			var sprite = bulletInstance.get_node("Sprite2D")
			var sprite2 = bulletInstance.get_node("Sprite2D2")
			if sprite and sprite2:
				sprite.visible = false
				sprite2.visible = true
		bulletInstance.position = self.global_position
		var bullet_direction = base_direction.rotated(deg_to_rad(current_angle))
		bulletInstance.set_rotation_angle(bullet_direction)
		self.add_child(bulletInstance)
		current_angle += angle_step
		
		if i < gunNum - 1:
			await get_tree().create_timer(0.1).timeout  # Ждем 0.1 секунды перед созданием следующего ножа

func fire():
	if intervalTimer.is_stopped():
		create_bullet()
		emit_signal("bullet_created")
		intervalTimer.start(atkInterval)

func level_up():
	level += 1
	updParams()

func active():
	self.is_active = true

func set_damage():
	baseParams[1] += 0.75
