class_name Player
extends CharacterBody2D

@export var max_health: int = 100
var health: int

@onready var animated_sprite := $AnimatedSprite2D
@onready var hurt_box := $HurtBox
@onready var hit_box := $HitBox
@onready var gun_sprite := $Gun
@onready var state_machine := $StateMachine
var last_dir := "down"
var flipped := false

func _ready() -> void:
	health = max_health
	
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
		flipped = input_dir.x < 0
		animated_sprite.flip_h = flipped
		gun_sprite.flip_h = flipped
		animated_sprite.offset.x = -3 if animated_sprite.flip_h else 0
		gun_sprite.offset.x = -10 if gun_sprite.flip_h else 0
	return last_dir
	
func play_animation(anim_name: String, input_dir: Vector2):
		var dir_suffix = get_dir_suffix(input_dir)
		#print("dir_suffix:", dir_suffix)
		animated_sprite.play(anim_name + "_" + dir_suffix)

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	print(health)
	if health <= 0:
		return
	health -= amount
	velocity += knockback
	if health <= 0:
		state_machine.transition_to("Die")
	
func _physics_process(_delta):
	
	move_and_slide()
