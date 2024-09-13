extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/stakes.tscn")
@onready var player = get_parent()
@export var angular_speed = 2
@export var radius = 300
var is_active = false

var level = 1

# Базовые параметры (atkInterval, dmg, bulletLife, gunNum)
var baseParams = Vector4(15, 1, 8, 1)

# Модификаторы, которые будут увеличиваться с каждым уровнем (atkInterval, dmg, bulletLife, gunNum)
var modifiers = Vector4(-1.5, 1.3, 1, 0.5)

# Коэффициент для замедляющегося прироста
var lambda = 0.139

# Бонусные параметры, которые будут суммироваться с базовыми
var bonusParams = Vector4(0, 0, 0, 0)

var atkInterval
var dmg
var spread #in degrees
var gunNum
var bulletLife

# Функция для расчета бонуса на основе уровня
func get_bonus(level):
	return modifiers * exp(-lambda * (level - 1))

# Функция для обновления параметров
func updParams():
	# Рассчитываем бонусы и суммируем с базовыми параметрами
	bonusParams += get_bonus(level)
	atkInterval = round_to_decimals(baseParams.x + bonusParams.x, 2)
	if atkInterval <= 6:
		atkInterval = 6  # Устанавливаем минимальный предел для atkInterval
	dmg = round_to_decimals(baseParams.y + bonusParams.y, 1)
	bulletLife = round_to_decimals(baseParams.z + bonusParams.z, 0)
	gunNum = round_to_decimals(baseParams.w + bonusParams.w, 0)
	
	print("Level:", level, " Params: atkInterval=", atkInterval, " dmg=", dmg, " spread=", spread, " gunNum=", gunNum)

func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

func _ready():
	updParams()
	Upgrades.giveDamageStakes.connect(self.set_damage)
	Upgrades.levelUpStakes.connect(self.level_up)
	Upgrades.activateStakes.connect(self.active)

func _process(delta):
	fire()

func create_bullet():
	if is_active:
		var angle_step = 2 * PI / gunNum
		for i in range(gunNum):
			var bulletInstance = bulletType.instantiate()
			bulletInstance.set_dmg(dmg)
			bulletInstance.set_angular_speed(angular_speed)
			bulletInstance.set_radius(radius)
			bulletInstance.set_waitTime(bulletLife)
			self.add_child(bulletInstance)
			var initial_angle = i * angle_step
			bulletInstance.global_position = self.global_position + Vector2(cos(initial_angle), sin(initial_angle)) * radius
			bulletInstance.angle = initial_angle
			bulletInstance.update_position_and_rotation(0)

func fire():
	if intervalTimer.is_stopped():
		create_bullet()
		intervalTimer.start(atkInterval)

func level_up():
	level += 1
	updParams()
	create_bullet()
	intervalTimer.start(atkInterval)

func active():
	self.is_active = true

func set_damage():
	baseParams.y += 0.25
	print(baseParams.y)
