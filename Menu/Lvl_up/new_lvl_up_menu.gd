extends Control

const button = preload("res://Menu/Lvl_up/panel_update.tscn")
@onready var father = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.disabled = true
	$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lvl_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Upgrades.get_upgrade()
	self.queue_free()

func lvl_up():
	var used_indices = []
	var upgrades = Upgrades.assign_upgrade_ids()
	while len(used_indices) < 4:
		var random_index = randi_range(0, upgrades.size() - 1)
		if not used_indices.has(random_index):
			used_indices.append(random_index)
			var buttonInstantiate = button.instantiate()
			buttonInstantiate.newIndex.connect(self.updateButton)
			buttonInstantiate.set_upgrade(upgrades[random_index])
			father.add_child(buttonInstantiate)

func updateButton():
	$Button.disabled = false
	$Button.mouse_filter = Control.MOUSE_FILTER_PASS
