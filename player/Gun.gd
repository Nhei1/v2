extends Marker2D

@onready var intervalTimer = $AttackInterval

const bulletType = preload("res://bullets/knive.tscn")
var attackInterval = 0.5
@onready var player = get_parent()
var level = 1

var levelparams = { #attackspeed, damage, gunnums
	1: [0.5, 1, 1],
	2: [0.4, 2, 1],
	3: [0.4, 4, 2]
}

func create_bullet():
	var bulletInstance = bulletType.instantiate()
	bulletInstance.rotation = get_parent().get_node("Sprite2D").rotation
	bulletInstance.set_rotation_angle(get_angle_to(get_global_mouse_position()))
	bulletInstance.position = self.global_position
	bulletInstance.set_rotation_angle(player.get_direction())
	#bulletInstance.look_at(player.get_direction())
	#print(bulletInstance.look_at(player.get_direction()))
	self.add_child(bulletInstance)

func fire():
	if intervalTimer.is_stopped():
		create_bullet()
		intervalTimer.start(attackInterval)

func _process(delta):
	fire()

func level_up():
	#применяем 
	attackInterval = attackInterval - attackInterval * 0.1
