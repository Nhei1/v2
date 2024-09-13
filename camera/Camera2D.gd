extends Camera2D

@onready var player = get_node_or_null("/root/World/Player")

func _ready():
	if is_instance_valid(player):
		self.position = player.position 

func _physics_process(delta):
	if is_instance_valid(player):
		self.position = player.position
	else:
		queue_free()  # Удаляем камеру, если игрока нет (или игрок был удалён)
