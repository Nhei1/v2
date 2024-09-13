extends Area2D

var speed = randf_range(100, 300) # Случайная скорость
var Gravity = 3 # Гравитационная постоянная
var velocity = Vector2.ZERO
var Rotation = 0.3
var dmgDin = 1


@onready var explosion = preload("res://bullets/explosion/explosion.tscn")

func _ready() -> void:
	set_as_top_level(true)
	var angle: float = randf_range(PI, 2 * PI) # Случайный угол в радианах
	velocity = Vector2(cos(angle), sin(angle)) * speed # Случайная скорость в заданном направлении

func _physics_process(delta: float) -> void:
	velocity.y += (gravity * 0.1) * delta # применяем гравитацию к y-компоненте скорости
	global_position += velocity * delta # Обновляем позицию
	if not gravity == 0:
		$AnimPlayer.play("wick")

func explode() -> void:
	var boom = explosion.instantiate()
	boom.position = self.global_position
	boom.set_dmg(dmgDin)
	get_parent().add_child(boom)



func _on_timer_timeout():
	Rotation = 0.01
	velocity *= Vector2.ZERO
	gravity *= 0 
	$AnimPlayer.stop()
	$AnimPlayer.play("boom")
	$Timer2.start()

func _on_timer_2_timeout():
	explode() 
	self.queue_free()


func _on_timer_3_timeout():
	$Sprite2D.rotation += Rotation

func set_dmg(dmg):
	self.dmgDin = dmg
