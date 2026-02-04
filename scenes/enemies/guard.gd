extends CharacterBody2D

@export var max_health: int = 100
@export var speed: float
@export var damage: int = 10 

@export var hero_path: NodePath
@export var follow_distance: float = 300.0
@export var attack_distance: float = 15.0
@export var attack_cooldown: float = 0.8
@export var hit_stun_time: float = 0.2

@onready var hero: CharacterBody2D = get_node_or_null(hero_path)
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var health: int
var attack_timer: float = 0.0
var hit_timer: float = 0.0

enum State { FOLLOW, ATTACK, HIT, DIE }
var state: State = State.FOLLOW

func _ready() -> void:
	health = max_health
	if hero == null:
		# Fallback: try find by name (still brittle, but better than crashing instantly)
		hero = get_tree().current_scene.get_node_or_null("Hero")

func follow_player() -> void:
	if hero == null:
		velocity = Vector2.ZERO
		return

	var to_hero := hero.global_position - global_position
	var dist := to_hero.length()

	# Too far away? you might want to leash/teleport/despawn instead
	if dist > follow_distance:
		velocity = Vector2.ZERO
		animation.play("idle")
		return

	if dist <= attack_distance:
		velocity = Vector2.ZERO
		state = State.ATTACK
		return

	velocity = to_hero.normalized() * speed
	animation.play("move")

func attack() -> void:
	if hero == null:
		state = State.FOLLOW
		return

	var dist := global_position.distance_to(hero.global_position)
	if dist > attack_distance:
		state = State.FOLLOW
		return

	velocity = Vector2.ZERO
	animation.play("attack")

	attack_timer -= get_process_delta_time()
	if attack_timer <= 0.0:
		attack_timer = attack_cooldown
		_do_damage()

func _do_damage() -> void:
	# This expects Hero to have a method like: apply_damage(amount)
	if hero.has_method("apply_damage"):
		hero.call("apply_damage", damage)

func die() -> void:
	velocity = Vector2.ZERO
	if animation.sprite_frames.has_animation("die"):
		animation.play("die")
	# If you want to wait for animation end, connect animation_finished.
	queue_free()

func take_hit() -> void:
	velocity = Vector2.ZERO
	animation.play("hit")

	hit_timer -= get_process_delta_time()
	if hit_timer <= 0.0:
		state = (health <= 0) if State.DIE else State.FOLLOW

func apply_damage(amount: int) -> void:
	if state == State.DIE:
		return

	health -= amount
	if health <= 0:
		state = State.DIE
	else:
		state = State.HIT
		hit_timer = hit_stun_time

func _process(delta: float) -> void:
	match state:
		State.ATTACK:
			attack()
		State.FOLLOW:
			follow_player()
		State.HIT:
			take_hit()
		State.DIE:
			die()
	
	animation.flip_h = global_position.x > hero.global_position.x
	

		

func _physics_process(delta: float) -> void:
	move_and_slide()
