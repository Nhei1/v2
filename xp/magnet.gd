extends Area2D

signal magnet_picked_up

func _ready():
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("-------------------------------------------------------------------------")
		body.on_magnet_picked_up(body)
		queue_free()
