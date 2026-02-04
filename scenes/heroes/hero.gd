extends CharacterBody2D
class_name Hero

@onready var tree = $AnimationTree
@onready var sprite = $Body
@onready var gun_sprite = $GunSprite
@onready var muzzle: Marker2D = $GunSprite/Muzzle

@export var speed := 100.0
@export var health := 100.0
@export var damage := 100.0

@export var bullet_scene: PackedScene
@export var fire_rate: float = 10.0   # bullets per second

var dir := Vector2.ZERO
var _shoot_cd: float = 0.0

func _ready():
	tree.active = true

func _physics_process(delta):
	move()

	velocity = dir * speed
	move_and_slide()

	update_animations()

	# shooting cooldown tick
	_shoot_cd = max(0.0, _shoot_cd - delta)

	# Shoot input (create an action named "shoot" in Input Map)
	if Input.is_action_pressed("shoot"):
		shoot()

func move():
	dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

func update_animations():
	tree.set("parameters/BlendSpace2D/blend_position", dir)

	# Flip based on movement x (your current logic)
	if dir.x < 0:
		sprite.flip_h = false
		gun_sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = true
		gun_sprite.flip_h = false

func shoot() -> void:
	if bullet_scene == null:
		return
	if _shoot_cd > 0.0:
		return

	_shoot_cd = 1.0 / fire_rate

	var b: Bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)

	# Aim direction: mouse-based (recommended)
	var aim_dir := (get_global_mouse_position() - muzzle.global_position).normalized()
	if aim_dir == Vector2.ZERO:
		aim_dir = Vector2.RIGHT

	b.global_position = muzzle.global_position
	b.dir = aim_dir
	b.damage = int(damage)  # or keep bullet damage separate if you want

	# Optional: rotate bullet to face direction
	b.rotation = aim_dir.angle()

func apply_damage(amount: int) -> void:
	health -= amount
