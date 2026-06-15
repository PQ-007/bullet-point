extends CharacterBody2D

## Enemy that chases the hero and attacks it in melee range.
##
## The hero is resolved through the "player" group, so the guard works no
## matter where it is instanced in the scene tree.

@export var max_health: int = 100
@export var speed: float = 30.0
@export var damage: int = 10

@export var follow_distance: float = 300.0
@export var attack_distance: float = 15.0
@export var attack_cooldown: float = 0.8
@export var hit_stun_time: float = 0.2
@export var death_lifetime: float = 1.0  # how long the corpse lingers while the death anim plays

## When set, the enemy shoots this projectile each attack instead of meleeing.
## Combine with a large attack_distance to make a ranged unit (e.g. the Archer).
@export var arrow_scene: PackedScene

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var health_bar := get_node_or_null("HealthBar") as HealthBar

enum State { FOLLOW, ATTACK, HIT, DIE }

var hero: Node2D
var health: int
var state: State = State.FOLLOW
var _attack_timer: float = 0.0
var _hit_timer: float = 0.0

func _ready() -> void:
	health = max_health
	hero = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	match state:
		State.FOLLOW:
			_follow()
		State.ATTACK:
			_attack(delta)
		State.HIT:
			_take_hit(delta)
		State.DIE:
			pass
	_update_facing()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _has_hero() -> bool:
	return hero != null and is_instance_valid(hero)

func _follow() -> void:
	if not _has_hero():
		velocity = Vector2.ZERO
		animation.play("idle")
		return

	var to_hero := hero.global_position - global_position
	var dist := to_hero.length()

	if dist > follow_distance:
		velocity = Vector2.ZERO
		animation.play("idle")
		return

	if dist <= attack_distance:
		velocity = Vector2.ZERO
		_attack_timer = 0.0
		state = State.ATTACK
		return

	velocity = to_hero.normalized() * speed
	animation.play("move")

func _attack(delta: float) -> void:
	if not _has_hero():
		state = State.FOLLOW
		return

	if global_position.distance_to(hero.global_position) > attack_distance:
		state = State.FOLLOW
		return

	velocity = Vector2.ZERO
	animation.play("attack")

	_attack_timer -= delta
	if _attack_timer <= 0.0:
		_attack_timer = attack_cooldown
		if arrow_scene != null:
			_fire_arrow()
		elif hero.has_method("apply_damage"):
			hero.apply_damage(damage)

## Spawn an arrow aimed at the hero and parent it in the level's Projectiles
## container so it lives independently of this enemy.
func _fire_arrow() -> void:
	var aim := (hero.global_position - global_position).normalized()
	if aim == Vector2.ZERO:
		aim = Vector2.RIGHT

	var arrow := arrow_scene.instantiate() as Arrow
	arrow.global_position = global_position + aim * 8.0
	arrow.dir = aim
	arrow.rotation = aim.angle()
	arrow.damage = damage
	_projectile_parent().add_child(arrow)

func _projectile_parent() -> Node:
	var scene := get_tree().current_scene
	var container := scene.get_node_or_null("Projectiles")
	return container if container != null else scene

func _take_hit(delta: float) -> void:
	velocity = Vector2.ZERO
	animation.play("take_hit")

	_hit_timer -= delta
	if _hit_timer <= 0.0:
		state = State.FOLLOW

func _update_facing() -> void:
	if _has_hero():
		animation.flip_h = global_position.x > hero.global_position.x

func apply_damage(amount: int) -> void:
	if state == State.DIE:
		return

	health -= amount
	if health_bar != null:
		health_bar.set_health(health, max_health)
	if health <= 0:
		_die()
	else:
		state = State.HIT
		_hit_timer = hit_stun_time

func _die() -> void:
	state = State.DIE
	velocity = Vector2.ZERO
	if health_bar != null:
		health_bar.hide()
	set_physics_process(false)
	# Let the corpse stop blocking movement and bullets.
	collision.set_deferred("disabled", true)
	if animation.sprite_frames.has_animation("die"):
		animation.play("die")
	# The "die" clip loops, so free after a fixed delay rather than waiting
	# on animation_finished (which never fires for a looping animation).
	await get_tree().create_timer(death_lifetime).timeout
	queue_free()
