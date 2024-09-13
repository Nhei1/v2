extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/Flame_vortex.tscn")
const fireTrailType = preload("res://bullets/FireTrail.tscn")
@onready var player = get_parent()

var level = 1

# Базовые параметры (atkInterval, dmg, spread, gunNum)
var baseParams = Vector4(1.4, 0.4, 5, 0.7)

# Модификаторы, которые будут увеличиваться с каждым уровнем (atkInterval, dmg, spread, gunNum)
var modifiers = Vector4(-0.1, 1.1, 3, 0.6)

# Коэффициент для замедляющегося прироста
var lambda = 0.139

# Бонусные параметры, которые будут суммироваться с базовыми
var bonusParams = Vector4(0, 0, 0, 0)

var atkInterval
var dmg
var spread #in degrees
var gunNum
var is_active = false
var last_spread_angle = 0.0

# Функция для расчета бонуса на основе уровня
func get_bonus(level):
	return modifiers * exp(-lambda * (level - 1))

# Функция для обновления параметров
func updParams():
	# Рассчитываем бонусы и суммируем с базовыми параметрами
	bonusParams += get_bonus(level)
	atkInterval = round_to_decimals(baseParams.x + bonusParams.x, 2)
	if atkInterval <= 0.7:
		atkInterval = 0.7
	dmg = round_to_decimals(baseParams.y + bonusParams.y, 1)
	spread = round_to_decimals(baseParams.z + bonusParams.z, 0)
	gunNum = round_to_decimals(baseParams.w + bonusParams.w, 0)
	
	
	
	print("Level:", level, " Params: atkInterval=", atkInterval, " dmg=", dmg, " spread=", spread, " gunNum=", gunNum)

func round_to_decimals(value: float, decimals: int) -> float:
	var scale = pow(10, decimals)
	return round(value * scale) / scale

func _ready():
	updParams()
	Upgrades.giveDamageFire.connect(self.set_damage)
	Upgrades.levelUpFire.connect(self.level_up)
	Upgrades.activateFire.connect(self.active)

func _process(delta):
	fire()

func create_bullet():
	if is_active:
		var vec = randf_range(0, 2 * PI)
		var _vec = Vector2(cos(vec), sin(vec))
		for i in range(gunNum):
			var bulletInstance = bulletType.instantiate()
			bulletInstance.set_dmg(dmg)
			if get_parent().get_movement() != Vector2.ZERO:
				bulletInstance.add_speed(get_parent().move_speed / 2)
			bulletInstance.position = self.global_position
			var spread_angle = last_spread_angle + randf_range(spread, 2 * spread)
			bulletInstance.set_rotation_angle(_vec.rotated(deg_to_rad(spread_angle)))
			last_spread_angle = spread_angle
			var fireTrailInstance = fireTrailType.instantiate()
			bulletInstance.add_child(fireTrailInstance)
			fireTrailInstance.position = Vector2.ZERO
			self.add_child(bulletInstance)

func fire():
	if intervalTimer.is_stopped():
		create_bullet()
		intervalTimer.start(atkInterval)

func level_up():
	level += 1
	updParams()

func active():
	self.is_active = true

func set_damage():
	baseParams.y += 0.5
	print(baseParams.y)
