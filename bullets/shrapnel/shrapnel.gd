extends Area2D

@export var speed = 400
@export var lifeTime = 2 #in secs

var angle = Vector2.ZERO

var damage = 1

func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	position += angle.normalized() * speed * delta

###   Custom functions   ###
func set_rotation_angle(initial_angle: float):
	angle = Vector2(cos(initial_angle), sin(initial_angle))

func set_speed(_speed):
	speed = _speed

func add_speed(_speed):
	speed += _speed

func get_dmg():
	return damage

func set_dmg(dmg):
	self.damage = dmg

###   Signals   ###

func _on_timer_timeout():
	self.queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDmg(self.get_dmg(), 50)
