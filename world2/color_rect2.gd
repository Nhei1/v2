extends ColorRect

@export var lightning_flash_duration: float = 0.2
@export var lightning_sound_delay_min: float = 0.5  # Минимальная задержка перед звуком
@export var lightning_sound_delay_max: float = 1.0  # Максимальная задержка перед звуком
@export var time_between_flashes_min: float = 2.0
@export var time_between_flashes_max: float = 12.0
@export var flash_intensity: float = 0.8

@onready var shader_material = self.material
@onready var lightning_sound = $LightningSound
@onready var filter_material = $ColorFilter.material

func _ready():
	randomize()
	_trigger_lightning()

func _trigger_lightning() -> void:
	# Запуск вспышки
	_start_lightning_flash()

	# Запуск звука после случайной задержки
	var sound_delay = randf_range(lightning_sound_delay_min, lightning_sound_delay_max)
	await get_tree().create_timer(sound_delay).timeout
	lightning_sound.play()

	# Планирование следующей вспышки
	var next_flash_time = randf_range(time_between_flashes_min, time_between_flashes_max)
	await get_tree().create_timer(next_flash_time).timeout
	_trigger_lightning()

func _start_lightning_flash() -> void:
	# Устанавливаем яркость вспышки
	shader_material.set("shader_param/flash_intensity", flash_intensity)
	
	# Ждем завершения вспышки (независимо от звука)
	await get_tree().create_timer(lightning_flash_duration).timeout
	
	# Отключаем вспышку
	shader_material.set("shader_param/flash_intensity", 0.0)
