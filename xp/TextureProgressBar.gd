extends TextureProgressBar

@onready var player = get_node("/root/World/Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	player.xp_update.connect(self.on_xp_update)
	player.max_xp_changed.connect(self._on_max_xp_changed)
	player.bar0.connect(self.BarNeedZero)
	

func on_xp_update(current_xp):
	self.value = current_xp

func _on_max_xp_changed(new_max_xp):
	max_value = new_max_xp

func BarNeedZero():
	value = 0

func _process(delta):
	pass
