class_name Player
extends CharacterBody2D

@export var move_speed := 100.0
@onready var animated_sprite := $AnimatedSprite2D
var last_dir := "down"

func get_dir_suffix(input_dir: Vector2) -> String:
	if input_dir == Vector2.ZERO:
		return last_dir
	
	if abs(input_dir.y) > abs(input_dir.x):
		last_dir = "top" if input_dir.y < 0 else "down"
		animated_sprite.flip_h = false
	else:
		last_dir = "lr"
		if input_dir.x < 0:
			animated_sprite.flip_h = true
			
		else:
			animated_sprite.flip_h = false
			
	return last_dir
	
func play_animation(anim_name: String, input_dir: Vector2):
		var dir_suffix = get_dir_suffix(input_dir)
		#print("dir_suffix:", dir_suffix)
		animated_sprite.play(anim_name + "_" + dir_suffix)
	
	
func _physics_process(_delta):
	
	move_and_slide()
