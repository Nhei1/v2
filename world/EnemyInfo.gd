extends Label

var enemy_info_array = [
	{
		"name": "Forgotten",
		"description": "An annoying creature",
		"sprite": preload("res://enemies/Illustration2.png")
	},
	{
		"name": "Forest Sovereign",
		"description": "Its soul is untainted, aura damage doesn't harm it",
		"sprite": preload("res://enemies/Illustrat4ion2.png")
	},
	{
		"name": "Devourer",
		"description": "This beast is harder to kill than the others",
		"sprite": preload("res://enemies/monster7.png")
	}
	# ... другие враги ...
]

func update_enemy_info(enemy_index):
	#text = "Sobriquet: %s\n%s" % [enemy_info_array[enemy_index]["name"], enemy_info_array[enemy_index]["description"]]
	pass
