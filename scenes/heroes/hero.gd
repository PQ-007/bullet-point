extends CharacterBody2D
class_name Hero

## Player character: WASD to move, aim the gun with the mouse, hold "shoot" to fire.

signal health_changed(current: float, maximum: float)
signal died

@onready var tree: AnimationTree = $AnimationTree
@onready var sprite: Sprite2D = $Body
@onready var gun_sprite: Sprite2D = $GunSprite
@onready var muzzle: Marker2D = $GunSprite/Muzzle

@export var speed := 100.0
@export var max_health := 100.0
@export var bullet_damage := 25

@export var bullet_scene: PackedScene
@export var fire_rate: float = 10.0   # bullets per second

var health: float
var dir := Vector2.ZERO

var _shoot_cd: float = 0.0
var _alive := true

func _ready() -> void:
	tree.active = true
	health = max_health
	health_changed.emit(health, max_health)

func _physics_process(delta: float) -> void:
	if not _alive:
		return

	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * speed
	move_and_slide()

	_update_animations()
	_aim_gun()

	_shoot_cd = max(0.0, _shoot_cd - delta)
	if Input.is_action_pressed("shoot"):
		shoot()

func _update_animations() -> void:
	tree.set("parameters/BlendSpace2D/blend_position", dir)

	# Body faces its movement direction.
	if dir.x < 0:
		sprite.flip_h = false
	elif dir.x > 0:
		sprite.flip_h = true

## Rotate the gun so the barrel points at the mouse, keeping it upright.
func _aim_gun() -> void:
	var aim := get_global_mouse_position() - gun_sprite.global_position
	if aim.length_squared() < 0.0001:
		return
	gun_sprite.rotation = aim.angle()
	# When pointing left the sprite would be upside down; flip it back upright.
	gun_sprite.flip_v = absf(gun_sprite.rotation) > PI / 2.0

func shoot() -> void:
	if bullet_scene == null or _shoot_cd > 0.0:
		return
	_shoot_cd = 1.0 / fire_rate

	var aim_dir := (get_global_mouse_position() - muzzle.global_position).normalized()
	if aim_dir == Vector2.ZERO:
		aim_dir = Vector2.RIGHT

	var b: Bullet = bullet_scene.instantiate()
	b.global_position = muzzle.global_position
	b.dir = aim_dir
	b.damage = bullet_damage
	b.rotation = aim_dir.angle()
	_projectile_parent().add_child(b)

func _projectile_parent() -> Node:
	# Keep projectiles in their own container if the scene provides one.
	var scene := get_tree().current_scene
	var container := scene.get_node_or_null("Projectiles")
	return container if container != null else scene

func apply_damage(amount: int) -> void:
	if not _alive:
		return

	health = max(0.0, health - amount)
	health_changed.emit(health, max_health)
	if health <= 0.0:
		_die()

func _die() -> void:
	_alive = false
	velocity = Vector2.ZERO
	died.emit()
