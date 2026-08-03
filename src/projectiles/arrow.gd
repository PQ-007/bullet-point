class_name Arrow
extends Area2D

var direction: Vector2 = Vector2.from_angle(-45)
var speed: float = 200.0
var damage: int = 6
var active: bool = false
var sprite
@export var lifetime: float = 3.0
var timer: float = 0.0

func _ready() -> void:
	sprite = $Sprite2D
	area_entered.connect(_on_area_entered)
	monitoring = false  # off until fired

func setup(dir: Vector2, move_speed: float, dmg: int) -> void:
	direction = dir.normalized()
	speed = move_speed
	damage = dmg
	rotation = direction.angle()
	active = true
	set_deferred("monitoring", true)

func _physics_process(delta: float) -> void:
	if not active:
		return
	global_position += direction * speed * delta
	timer += delta
	if timer >= lifetime:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurtbox"):
		return
	if area.has_method("take_hit"):
		area.take_hit(damage, direction * 100.0)
	queue_free()
