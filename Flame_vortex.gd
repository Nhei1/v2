extends Area2D

var speed = 300
var damage = 10
var radius = 50

var surface_texture = preload("res://surface.png")
var surface_sprite = null
var surface_damage = 5
var surface_duration = 5
var surface_timer = 0
@onready var fire_spawn = $FireSpawn


var enemies = []

var velocity = Vector2(1, 0) * speed

func _ready():
	var enemy = get_node("res://enemies/Enemy.gd")

func create():
	var x = position.x
	var y = position.y
	var steps = 50
	
	# Инициализация генератора случайных чисел
	randomize()
	
	for i in range(steps):
		var fire = load("res://faerball.png").instance()
		
		# Генерация случайного угла в радианах
		var random_angle = deg_to_rad(randf_range(0, 360))       
		# Вычисление случайного направления
		var random_direction = Vector2(cos(random_angle), sin(random_angle))       
		var offset_distance = 20
		var offset_position = position + random_direction * offset_distance
		fire.position = fire_spawn.global_position
		fire_spawn.add_child(fire)
		fire.velocity = random_direction * speed
	# Создание поверхности
	var surface_area = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	surface_area.shape = shape
	add_child(surface_area)
	surface_area.position = Vector2(x, y)
	surface_sprite = Sprite2D.new()
	surface_sprite.texture = surface_texture
	add_child(surface_sprite)
	surface_sprite.position = Vector2(x, y)

func _physics_process(delta):
	# Создание урона на поверхности
	if surface_sprite and surface_timer > 0:
		for i in enemies:
			if i.position.distance_to(global_position) < radius:
				i.takeDmg(surface_damage)
			surface_timer -= delta
			if surface_timer <= 0:
				surface_sprite.queue_free()
				surface_sprite = false

# Функция для добавления врагов в массив
func add_enemy(enemy):
	enemies.append(enemy)

# Функция для удаления врагов из массива
func remove_enemy(enemy):
	enemies.erase(enemy)
