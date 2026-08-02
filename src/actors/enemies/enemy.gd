class_name Enemy
extends CharacterBody2D

@export var stats: EnemyStats

var health: int
var detect_range: float
var attack_range: float
var move_speed: float
var flipped := false
var player: Player


@onready var animated_sprite := $AnimatedSprite2D
@onready var hurt_box := $HurtBox
@onready var hit_box := $HitBox
@onready var state_machine := $StateMachine

func _ready() -> void:
	health = stats.max_health
	detect_range = stats.detect_range
	attack_range = stats.attack_range
	move_speed = stats.move_speed
	
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")

func flip_sprite(move_dir: Vector2) -> void:
	if move_dir.x == 0:
		return  # don't change facing on pure vertical movement
	flipped = move_dir.x < 0
	animated_sprite.flip_h = flipped

func play_animation(anim_name: String) -> void:
	animated_sprite.play(anim_name)

func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if health <= 0:
		return
	health -= amount
	if health <= 0:
		state_machine.transition_to("Die")
	else:
		state_machine.transition_to("Hurt", {"knockback": knockback})

func _physics_process(_delta):
	move_and_slide()
