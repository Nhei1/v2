extends Node

var level = 1
var selected_weapon_upgrades = []  # Список уже выбранных улучшений оружия
var selected_upgrades = []  # Список уже выбранных обычных улучшений
var active_weapons = [] 
var selected_upgrade: int = -1

signal lvl_up_done
signal levelUpAura
signal activateAura
signal levelUpStakes
signal activateStakes
signal levelUpFire
signal activateFire
signal levelUpBomb
signal activateBomb
signal levelUpDin
signal activateDin
signal levelUpKnife
signal activateKnife
signal levelUpPoison
signal activatePoison
signal giveDamageAura
signal giveDamageStakes
signal giveDamageFire
signal giveDamageDin
signal giveDamageBomb
signal giveDamageKnife
signal giveDamagePoison
signal giveSpeed
signal giveHealth
signal giveArmor

var weapon_upgrades_data = [
	{"index": 0, "upgrade": "Knife", "icon": "res://icons/Knife_.png", "activated": false},
	{"index": 1, "upgrade": "FireSpawn", "icon": "res://icons/fire.png", "activated": false},
	{"index": 2, "upgrade": "Aura", "icon": "res://icons/Aura_.png", "activated": false},
	{"index": 3, "upgrade": "Stakes", "icon": "res://icons/Stakes.png", "activated": false},
	{"index": 4, "upgrade": "Bomb", "icon": "res://icons/Bomb.png", "activated": false},
	{"index": 5, "upgrade": "Poison", "icon": "res://icons/Poison.png", "activated": false},
	{"index": 6, "upgrade": "Dinamite", "icon": "res://icons/Din.png", "activated": false},
]

var upgrades_data = [
	{"index": 0, "upgrade": "Health", "icon": "res://icons/Health Upgrade.png"},
	{"index": 1, "upgrade": "Speed", "icon": "res://icons/Speed Upgrade.png"},
	{"index": 2, "upgrade": "Armor", "icon": "res://icons/Armor Upgrade.png"},
	{"index": 3, "upgrade": "Damage", "icon": "res://icons/Extra Upgrade 2.png"}
]

var shop_upgrades_data = [
	{"name": "Knife Boost", "description": "Increases damage by 15%", "cost": 150, "icon": "res://icons/Weapon Upgrade.png", "current_purchases": 0},
	{"name": "Health Boost", "description": "Increases health by 20%", "cost": 200, "icon": "res://icons/Health Upgrade.png", "current_purchases": 0},
	{"name": "Speed Boost", "description": "Increases speed by 10%", "cost": 100, "icon": "res://icons/Speed Upgrade.png", "current_purchases": 0},

]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func assign_upgrade():
	return shop_upgrades_data

func update():
	active_weapons = [] 
	level = 1

func assign_upgrade_ids():
	if level == 1 or level % 3 == 0:
		return weapon_upgrades_data

	return upgrades_data

func set_level(level):
	self.level = level

func get_level():
	return level

func set_upgrade(index):
	self.selected_upgrade = index

func get_upgrade():
	if selected_upgrade == -1:
		print("Ошибка: selected_upgrade не инициализирован!")
		return -1  # Или бросить исключение, если это необходимо
	applyUpgrades(assign_upgrade_ids()[selected_upgrade])

# Добавляем объект оружия в активные
func applyUpgrades(upgrade_data):
	var upgrade_name = upgrade_data["upgrade"]
	print("Applying upgrade: %s" % upgrade_name)
	emit_signal("lvl_up_done")
	
	match upgrade_name:
		"Knife":
			if active_weapons.has("Knife"):
				emit_signal("levelUpKnife")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateKnife")
				if "Knife" not in active_weapons:
					active_weapons.append("Knife")
		"FireSpawn":
			if active_weapons.has("FireSpawn"):
				emit_signal("levelUpFire")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateFire")
				if "FireSpawn" not in active_weapons:
					active_weapons.append("FireSpawn")
		"Aura":
			if active_weapons.has("Aura"):
				emit_signal("levelUpAura")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateAura")
				if "Aura" not in active_weapons:
					active_weapons.append("Aura")
		"Stakes":
			if active_weapons.has("Stakes"):
				emit_signal("levelUpStakes")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateStakes")
				if "Stakes" not in active_weapons:
					active_weapons.append("Stakes")
		"Bomb":
			if active_weapons.has("Bomb"):
				emit_signal("levelUpBomb")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateBomb")
				if "Bomb" not in active_weapons:
					active_weapons.append("Bomb")
		"Poison":
			if active_weapons.has("Poison"):
				emit_signal("levelUpPoison")
			else:
				upgrade_data["activated"] = true
				emit_signal("activatePoison")
				if "Poison" not in active_weapons:
					active_weapons.append("Poison")
		"Dinamite":
			if active_weapons.has("Dinamite"):
				emit_signal("levelUpDin")
			else:
				upgrade_data["activated"] = true
				emit_signal("activateDin")
				if "Dinamite" not in active_weapons:
					active_weapons.append("Dinamite")
		"Damage":
			apply_damage_upgrade()

		"Speed":
			emit_signal("giveSpeed")
		"Health":
			emit_signal("giveHealth")
		"Armor":
			emit_signal("giveArmor")



# Проверка, активирован ли апгрейд
func activate():
	return true

# Функция для применения улучшения урона
func apply_damage_upgrade():
	if active_weapons.size() == 0:
		print("No active weapons")
	elif active_weapons.size() == 1:
		# Если одно оружие, отправляем дважды
		var weapon = active_weapons[0]
		emit_damage_signal(weapon)
		emit_damage_signal(weapon)
	elif active_weapons.size() == 2:
		# Если два оружия, отправляем каждому по одному разу
		emit_damage_signal(active_weapons[0])
		emit_damage_signal(active_weapons[1])
	else:
		# Если больше двух оружий, выбираем два случайных
		var first_weapon = active_weapons[randi_range(0, active_weapons.size() - 1)]
		var second_weapon = active_weapons[randi_range(0, active_weapons.size() - 1)]
		while first_weapon == second_weapon:
			second_weapon = active_weapons[randi_range(0, active_weapons.size() - 1)]
		
		emit_damage_signal(first_weapon)
		emit_damage_signal(second_weapon)

# Функция для отправки соответствующего сигнала урона
func emit_damage_signal(weapon):
	match weapon:
		"Knife":
			emit_signal("giveDamageKnife")
		"FireSpawn":
			emit_signal("giveDamageFire")
		"Aura":
			emit_signal("giveDamageAura")
		"Stakes":
			emit_signal("giveDamageStakes")
		"Bomb":
			emit_signal("giveDamageBomb")
		"Poison":
			emit_signal("giveDamagePoison")
		"Dinamite":
			emit_signal("giveDamageDin")
