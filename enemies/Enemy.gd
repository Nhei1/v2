extends Area2D

var moveSpeed = 35
var velocity = Vector2.ZERO
var player = null

func _ready():
	player = get_node("/root/World/Player")

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = (player.position - position).normalized() * moveSpeed
	position += velocity * delta

func _on_Enemy_area_entered(area):
	if area.is_in_group("bullet"):
		if "rocket" in area.name:
			area.explode()
		self.queue_free()

func die():
	self.queue_free()


func _on_Enemy_visibility_changed():
	pass
	#if self.position in Globals.get_screen_size():
	#	print("Cant see me!")
