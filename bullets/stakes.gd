extends Area2D

@export var speed = 400
@export var lifeTime = 2 #in secs

@onready var timer = $Timer
@onready var sprite = $Sprite2D

var angle = Vector2.ZERO

var penetrated = 0
var damage = 1
var angular_speed = 2
var radius = 0

func _ready():
	set_as_top_level(true)
	timer.set_wait_time(lifeTime)

func _physics_process(delta):
	if not get_parent():
		return

	update_position_and_rotation(delta)

func update_position_and_rotation(delta):
	# Обновите позицию и вращение пули на основе угловой скорости
	angle += angular_speed * delta
	global_position = get_parent().global_position + Vector2(cos(angle), sin(angle)) * radius
	rotation = angle + PI / 2

###   Custom functions   ###

func set_speed(_speed):
	speed = _speed

func set_angular_speed(speed):
	angular_speed = speed

func add_speed(_speed):
	speed += _speed

func get_dmg():
	return damage

func set_dmg(dmg):
	damage = dmg

func set_radius(_radius):
	radius = _radius

func set_angle(_angle):
	angle = _angle

###   Signals   ###

func set_waitTime(sec):
	$Timer.set_wait_time(sec)

func _on_Timer_timeout():
	self.queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDmg(self.get_dmg(), 50)
