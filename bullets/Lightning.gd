extends Area2D

@export var speed = 250
@export var lifeTime = 2 #in secs
var damage = 1
var direction = Vector2.ZERO
@onready var timer = $Timer
@onready var sprite = $Sprite2D

func _ready():
	set_as_top_level(true)

func set_direction(vector):
	direction = vector
	$Sprite2D.look_at(direction + self.position)
	
func _physics_process(delta):
	position += direction.normalized() * speed * delta

func get_dmg():
	return damage

func set_dmg(dmg):
	damage = dmg


func add_speed(_speed):
	speed += _speed

func hitReg():
	pass

func _on_timer_timeout():
	self.queue_free()
