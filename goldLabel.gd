extends Label

var gold = 0
var cash = 0
@onready var panel = get_node("/root/Shop/Control")

func _ready():
	if panel != null:
		if panel.has_signal("update_gold"):
			panel.update_gold.connect(self.load_gold)
		else:
			print("Ошибка: Сигнал 'update_gold' не существует у узла 'panel'.")
	else:
		print("Ошибка: Узел 'panel' не найден.")
	load_gold()

func update_gold(cash):
	var money = gold + cash
	Saves.set_value("gold", money)
	text = str(money)

func load_gold():
	gold = Saves.get_value("gold", 0)
	text = str(gold)
