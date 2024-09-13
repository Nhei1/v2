extends Area2D

@export var speed = 400
@export var lifeTime = 2 #in secs

var angle = Vector2.ZERO

var damage = 1

func _ready():
	set_as_top_level(true)
	$AnimationPlayer.play("boom")

func _physics_process(delta):
	pass

func get_dmg():
	return damage

func set_dmg(dmg):
	self.damage = dmg

###   Signals   ###

func _on_timer_timeout():
	self.queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.takeDmg(self.get_dmg(), 100)
