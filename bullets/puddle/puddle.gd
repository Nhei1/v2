extends Area2D

@export var speed = 400
@export var lifeTime = 2 #in secs

var angle = Vector2.ZERO
var damage_timer = null
var damage_interval = 0.15

var damage = 0.1

func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	if self.scale <= Vector2(2,2):
		self.scale += Vector2(0.02,0.02)
	else:
		pass

###   Custom functions   ###


func set_speed(_speed):
	speed = _speed

func add_speed(_speed):
	speed += _speed

func get_dmg():
	return damage

func set_dmg(dmg):
	damage = dmg

###   Signals   ###

func _on_timer_timeout():
	self.queue_free()


func _on_timer_2_timeout() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			if not body.is_in_group("no poison"):
				body.call_deferred("takeDmg", damage, 0)
				body.set_slowdown(15, 1)
