extends Camera2D

@onready var player = get_node("/root/World/Player")

func _ready():
	if player:
		self.position = player.position 

func _physics_process(delta):
	if player:
		self.position = player.position
