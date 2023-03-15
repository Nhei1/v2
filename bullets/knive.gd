extends Area2D

@export var speed = 250
@export var lifeTime = 2 #in secs

@onready var timer = $Timer
@onready var sprite = $Sprite2D
var velocity = Vector2()
var angle = Vector2.ZERO
var direction = 1
var lvl_knive = 1

func _ready():
	#sprite.look_at(angle)
	set_as_top_level(true)
	timer.set_wait_time(lifeTime)

func _physics_process(delta):
	#print(angle)
	position += angle.normalized() * speed * delta
	#print(position).normalized()
	#print(position)

###   Custom functions   ###
func set_rotation_angle(vector):
	#print(radians)
	angle = vector
	
func set_speed(_speed):
	speed = _speed

func knive_lvl_up():
	lvl_knive += 1


###   Signals   ###
func _on_Bullet_area_entered(area):
	if area.is_in_group('enemy'):
		self.queue_free()

func _on_Timer_timeout():
	self.queue_free()
