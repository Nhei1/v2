
extends Area2D
var exp_amount: int = 1

signal picked_up

func _ready():
	set_as_top_level(true)
	self.set_collision_layer_value(2, true)

func _on_body_entered(body):
	print("Player entered:", body.name)
	if body.is_in_group("player"):
		body.gain_experiense(exp_amount)
		queue_free()
