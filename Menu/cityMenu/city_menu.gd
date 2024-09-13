extends Control

var world_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Menu//worldMenu/worldMenu.tscn")


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Menu/menu/menu.tscn")


func _on_shop_pressed():
	get_tree().change_scene_to_file("res://Menu/shop/shop.tscn")
