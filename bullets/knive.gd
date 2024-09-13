extends Area2D

@export var speed = 400
@export var lifeTime = 2 #in secs

@onready var timer = $Timer
@onready var sprite = $Sprite2D
@onready var sprite2 = $Sprite2D2

var angle = Vector2.ZERO

var penetratePwr = 2
var penetrated = 0
var damage = 1
var sprite_flipped = false

func _ready():
	set_as_top_level(true)
	timer.set_wait_time(lifeTime)
	if sprite:
		# Настраиваем flip_h только после того, как узел полностью инициализирован
		sprite.flip_v = sprite_flipped
		sprite2.flip_v = sprite_flipped
	else:
		print("Error: Sprite not found in _ready!")

func _physics_process(delta):
	position += angle.normalized() * speed * delta
	#print(damage)

###   Custom functions   ###
func set_rotation_angle(vector):
	angle = vector
	self.look_at(angle + self.position)
	sprite_flipped = angle.x < 0

func set_speed(_speed):
	speed = _speed

func add_speed(_speed):
	speed += _speed

func get_dmg():
	return damage

func set_dmg(dmg):
	damage = dmg

###   Signals   ###
func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDmg(self.get_dmg(), 100)
		self.hitReg()

func hitReg():
	penetrated += 1
	if penetrated == penetratePwr:
		self.queue_free()

func _on_Timer_timeout():
	self.queue_free()
