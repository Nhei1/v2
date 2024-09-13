extends Area2D

var speed = randf_range(100, 300) # Случайная скорость
var Gravity = 3 # Гравитационная постоянная
var velocity = Vector2.ZERO
var Rotation = 0.3
var dmgBomb = 1


@onready var shrapnel = preload("res://bullets/shrapnel/shrapnel.tscn")

func _ready() -> void:

	set_as_top_level(true)
	var angle: float = randf_range(PI, 2 * PI) # Случайный угол в радианах
	velocity = Vector2(cos(angle), sin(angle)) * speed # Случайная скорость в заданном направлении

func _physics_process(delta: float) -> void:
	velocity.y += (gravity * 0.1) * delta # применяем гравитацию к y-компоненте скорости
	global_position += velocity * delta # Обновляем позицию
	if not gravity == 0:
		$AnimPlayer.play("bombs")

func explode() -> void:
	var num_shrapnel: int = randi() % 4 + 4 # Создаем от 4 до 7 дробинок
	var angle_step = 2 * PI / num_shrapnel
	for i in range(num_shrapnel):
		var s = shrapnel.instantiate() # Создаем экземпляр дробинки
		s.set_dmg(dmgBomb)
		s.position = self.global_position
		var initial_angle = i * angle_step
		s.set_rotation_angle(initial_angle)
		get_parent().add_child(s) # Добавляем дробинку в сцену



func _on_timer_timeout():
	Rotation = 0.01
	velocity *= Vector2.ZERO
	gravity *= 0 
	$AnimPlayer.stop()
	$AnimPlayer.play("BOOOM")
	$Timer2.start()

func _on_timer_2_timeout():
	explode() # Создаем дробинки
	self.queue_free()


func _on_timer_3_timeout():
	$Sprite2D.rotation += Rotation

func set_dmg(dmg):
	self.dmgBomb = dmg
