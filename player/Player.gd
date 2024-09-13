extends CharacterBody2D

var move_speed = 100
var bonus_speed = 0
var direction = Vector2(1,0)
var input_vector = Vector2.ZERO
var armor = 0 
var fireSpawn_activated = false
var Aura_activated = false
var Stakes_activated = false
var Bomb_activated = false
var Poison_activated = false
var magnet_active = false
var din_activated = false
var magnet_speed = 900  # Скорость притягивания осколков
var health_lvl = 0

@onready var UpgradeMenu = get_node("/root/World/UI/Interface")
@onready var sprite = get_node("/root/World/Player/Sprite2D")
@onready var health_regen_timer = $HealthRegenTimer
@onready var health = max_health : set = _set_health

@export var bonus_health = 0
@export var max_health = 100


signal lvl_up()
signal health_update(health: float)
signal killed()
signal max_health_changed(new_max_health)
signal lvl_up_done()
signal xp_update(current_xp: float)
signal max_xp_changed(new_max_xp)
signal bar0



func _ready():
	Upgrades.update()
	Upgrades.giveHealth.connect(self.set_health)
	Upgrades.giveSpeed.connect(self.set_speed)
	Upgrades.giveArmor.connect(self.set_armor)
	
	var saved_bonus_health = Saves.get_value("upgrades/health/value", 0)
	var saved_bonus_speed = Saves.get_value("upgrades/speed/value", 0)
	
	bonus_health = saved_bonus_health
	bonus_speed = saved_bonus_speed
	
	max_health += bonus_health
	move_speed += bonus_speed
	
	health = max_health
	
	emit_signal("max_health_changed", max_health)
	emit_signal("health_update", health)
	
	$Gun.bullet_created.connect(self._on_Gun_bullet_created)
	get_experiense_required()


func _physics_process(delta):
	
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if input_vector != Vector2.ZERO: direction = input_vector 
	
	if input_vector.x == 1:
		sprite.flip_h = false
	elif input_vector.x == -1:
		sprite.flip_h = true
	else:
		pass

	#print (max_health)
	#print (move_speed)
	input_vector = input_vector.normalized() * (move_speed)
		
	set_velocity(input_vector)
	move_and_slide()



	if magnet_active:
		var shards = get_tree().get_nodes_in_group("XP")
		if shards.size() == 0:
			stop_magnet()
		else:
			for shard in shards:
				var direction = shard.global_position.direction_to(global_position).normalized()
				shard.global_position += direction * magnet_speed * delta
			
func getPosition() -> Vector2:
	return self.position

func getGlobalPosition() -> Vector2:
	return self.global_position

func get_direction() -> Vector2:
	return direction

func _input(event):
	pass

func get_movement():
	return input_vector

func get_total_max_health() -> int:
	return max_health + bonus_health

# HP manipulation
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	#print(health)
	if health != prev_health:
		emit_signal("health_update", health)
		if health == 0:
			kill()
			emit_signal("killed")

func damage(amount):
	amount = clamp(amount - armor, 1, amount)
	_set_health(health - amount)

func set_health():
	health_lvl += 1
	max_health += 5
	health += 5
	emit_signal("max_health_changed", max_health)
	emit_signal("health_update", health)
	if health_lvl == 3:
		$HealthRegenTimer.autostart = true

func set_speed():
	move_speed += 5

func set_armor():
	armor += 1

func _on_health_regen():
	# Восстановите здоровье на 1
	health += 1
	emit_signal("health_update", health)
	# Здесь вы можете ограничить максимальное значение здоровья
	health = min(health, max_health)

func kill():
	self.queue_free()

func _on_Gun_bullet_created():
	if input_vector.x == 100:
		$Sprite2D2.flip_h = false
		$AnimationPlayer.play("punch")
	elif input_vector.x == -100: 
		$Sprite2D2.flip_h = true
		$AnimationPlayer.play("punch")
	else:
		$AnimationPlayer.play("punch")

# LEVELING SYSTEM
@export var level = 1

var experiense = 0
var experience_total = 0
var experiense_required = 0

func get_required_experiense(level):
	return round(5 + (pow(level, 1.2) * 195 / pow(45, 1.2)))
	
func gain_experiense(amount):
	experience_total += amount
	experiense += amount
	emit_signal("xp_update", experiense)
	while experiense >= experiense_required:
		experiense -= experiense_required
		level_up()

func get_level():
	return level
func get_experiense_required():
	experiense_required = get_required_experiense(level)
	emit_signal("max_xp_changed", experiense_required)

func level_up():
	level += 1
	Upgrades.set_level(level)
	emit_signal("lvl_up")
	UpgradeMenu.lvl_up()
	experiense_required = get_required_experiense(level + 1)
	emit_signal("max_xp_changed", experiense_required)
	emit_signal("bar0")

func _on_area_entered(area):
	if area.is_in_group("XP"):
		area.picked_up.connect(self.gain_experiense)
	elif area.is_in_group("magnet"):
		area.magnet_picked_up.connect(self.on_magnet_picked_up)

func on_magnet_picked_up(player):
	magnet_active = true

func stop_magnet():
	magnet_active = false
	print("Магнит отключен, все осколки собраны.")


func _on_first_update_timer_timeout() -> void:
	emit_signal("lvl_up")
	UpgradeMenu.lvl_up()
