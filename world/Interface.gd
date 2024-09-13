extends Control

@onready var upgradeMenu = preload("res://Menu/Lvl_up/new_lvl_up_menu.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)

func lvl_up():
	var upgrade = upgradeMenu.instantiate()
	self.add_child(upgrade)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
