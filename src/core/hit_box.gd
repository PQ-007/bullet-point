class_name HitBox
extends Area2D

@export var damage: int = 10
@export var knockback_force: float = 200.0

var hit_targets: Array = []
var current_dir_vector: Vector2 = Vector2.DOWN

@onready var shape: CollisionShape2D = $HitBoxShape

func _ready() -> void:
	monitoring = false
	monitorable = false
	area_entered.connect(_on_area_entered)

func activate(offset: Vector2, box_size: Vector2, dir_vector: Vector2) -> void:
	hit_targets.clear()
	position = offset
	shape.shape.size = box_size
	current_dir_vector = dir_vector
	set_deferred("monitoring", true)

func deactivate() -> void:
	set_deferred("monitoring", false)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurtbox"):
		return
	if area.get_parent() == get_parent():
		return
	if area in hit_targets:
		return
	hit_targets.append(area)
	if area.has_method("take_hit"):
		area.take_hit(damage, current_dir_vector * knockback_force)
