extends TextureProgressBar

@onready var player = get_node("/root/World/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_update.connect(self.on_health_update)
	player.max_health_changed.connect(self._on_max_health_changed)
	

func on_health_update(current_health):
	self.value = current_health

func _on_max_health_changed(new_max_health):
	max_value = new_max_health

func _process(delta):
	pass
