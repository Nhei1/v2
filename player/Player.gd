extends CharacterBody2D

const move_speed = 100
var direction = Vector2(1,0)
@onready var sprite = get_node("/root/World/Player/Sprite2D")
#var velocity = Vector2.ZERO

func _ready():
	pass 

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if input_vector != Vector2.ZERO: direction = input_vector 
	
	if input_vector.x == 1:
		sprite.flip_h = false
	elif input_vector.x == -1:
		sprite.flip_h = true
	else:
		pass

	#print (direction)
	input_vector = input_vector.normalized() * move_speed
		
	set_velocity(input_vector)
	move_and_slide()
	
func getPosition() -> Vector2:
	return self.position
	
func get_direction() -> Vector2:
	return direction

func _input(event):
	pass



# LEVELING SYSTEM
@export var level = 1

var experiense = 0
var experience_total = 0
var experiense_required = 0

func get_required_experiense(level):
	return round(pow(level, 1.8) + level * 4)
	
func gain_experiense(amount):
	experience_total += amount
	experiense += amount
	while experiense >= experiense_required:
		experiense -= experiense_required
		level_up()

func get_level():
	return level

func level_up():
	#$Gun.level_up()
	level += 1
	experiense_required = get_required_experiense(level + 1)

