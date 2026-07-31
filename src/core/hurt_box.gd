class_name HurtBox
extends Area2D

signal hit_received(damage: int, knockback: Vector2)

func _ready() -> void:
	add_to_group("hurtbox")
	monitorable = true

func take_hit(damage: int, knockback: Vector2 = Vector2.ZERO) -> void:
	hit_received.emit(damage, knockback)
	var parent = get_parent()
	if parent.has_method("take_damage"):
		parent.take_damage(damage, knockback)
