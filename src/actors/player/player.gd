class_name Player
extends CharacterBody2D


@onready var animated_sprite := $AnimatedSprite2D
@onready var gun_sprite := $Gun
var last_dir := "down"

func get_dir_suffix(input_dir: Vector2) -> String:
	if input_dir == Vector2.ZERO:
		return last_dir
	
	if abs(input_dir.y) > abs(input_dir.x):
		last_dir = "top" if input_dir.y < 0 else "down"
		animated_sprite.flip_h = false
		gun_sprite.flip_h = false
		animated_sprite.offset.x = 0
		gun_sprite.offset.x = 0
	else:
		last_dir = "lr"
		animated_sprite.flip_h = input_dir.x < 0
		gun_sprite.flip_h = animated_sprite.flip_h
		animated_sprite.offset.x = -3 if animated_sprite.flip_h else 0
		gun_sprite.offset.x = -10 if gun_sprite.flip_h else 0
	return last_dir
	
func play_animation(anim_name: String, input_dir: Vector2):
		var dir_suffix = get_dir_suffix(input_dir)
		#print("dir_suffix:", dir_suffix)
		animated_sprite.play(anim_name + "_" + dir_suffix)
	
	
func _physics_process(_delta):
	
	move_and_slide()
