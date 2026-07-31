class_name HitBox
extends Area2D

@export var damage: int = 10
@export var knockback_force: float = 200.0

const OFFSET := 14.0
var hit_targets: Array = []

@onready var shape: CollisionShape2D = $HitBoxShape

func _ready() -> void:
	monitoring = false
	monitorable = false
	area_entered.connect(_on_area_entered)

func activate(direction: Vector2) -> void:
	hit_targets.clear()
	position = direction * OFFSET
	rotation = direction.angle()
	monitoring = true

func deactivate() -> void:
	monitoring = false

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurtbox"):
		return
	if area in hit_targets:
		return
	hit_targets.append(area)
	if area.has_method("take_hit"):
		var dir = (area.global_position - global_position).normalized()
		area.take_hit(damage, dir * knockback_force)
