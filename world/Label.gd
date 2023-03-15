extends Label

func update_text(level, experiense, experiense_required):
	text = """Level: %s
			Experiense: %s
			Next level: %s
	 		 """ % [level, experiense, experiense_required]
