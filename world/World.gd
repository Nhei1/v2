extends Node

@onready var _player = $Player
@onready var _label = $UI/Interface/Label
#onready var _bar = $Interface/ExperienseBar

func _ready():
	update_exp()

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		_player.gain_experiense(50)
		update_exp()

func update_exp():
	_label.update_text(_player.level, _player.experiense, _player.experiense_required)
