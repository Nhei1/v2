extends Area2D

var speed = randf_range(100, 300) # Случайная скорость
var Gravity = 3 # Гравитационная постоянная
var velocity = Vector2.ZERO
var Rotation = 0.3
var damage = 0.15


@onready var puddle = preload("res://bullets/puddle/puddle.tscn")

func _ready() -> void:
	set_as_top_level(true)
	var angle: float = randf_range(PI, 2 * PI) # Случайный угол в радианах
	velocity = Vector2(cos(angle), sin(angle)) * speed # Случайная скорость в заданном направлении

func _physics_process(delta: float) -> void:
	velocity.y += (gravity * 0.1) * delta # применяем гравитацию к y-компоненте скорости
	global_position += velocity * delta # Обновляем позицию
	
func explode() -> void:
	var pud = puddle.instantiate() # Создаем экземпляр дробинки
	pud.position = self.global_position
	pud.set_dmg(damage)
	get_parent().add_child(pud) # Добавляем дробинку в сцену



func _on_timer_timeout():
	Rotation = 0.01
	velocity *= Vector2.ZERO
	gravity *= 0 
	$Timer2.start()
	$AnimPlayer.play("glass")

func _on_timer_2_timeout():
	explode() # Создаем дробинки
	self.queue_free()


func _on_timer_3_timeout():
	$Sprite2D.rotation += Rotation

func set_dmg(dmg):
	self.damage = dmg
