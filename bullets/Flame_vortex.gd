extends Area2D

@export var speed = 250
@export var lifeTime = 2 #in secs
var damage = 1
var angle = Vector2.ZERO
@onready var timer = $Timer
@onready var sprite = $Sprite2D
var spread = 15

func _ready():
	set_as_top_level(true)

func set_rotation_angle(vector):
	angle = vector
	self.look_at(angle + self.position)
	
func _physics_process(delta):
	position += angle.normalized() * speed * delta

func get_dmg():
	return damage

func set_dmg(dmg):
	damage = dmg

func add_speed(_speed):
	speed += _speed

func _on_timer_timeout():
	self.queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDmg(self.get_dmg(), 100)
