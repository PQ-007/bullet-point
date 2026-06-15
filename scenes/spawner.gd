extends Node

## Periodically spawns enemies in a ring around the hero, up to a concurrent cap.
## Driven by the child Timer's "timeout" signal.

@export var enemy_scenes: Array[PackedScene] = [
	preload("res://scenes/enemies/guard.tscn"),
	preload("res://scenes/enemies/archer.tscn"),
]
@export var min_spawn_distance := 100.0
@export var max_spawn_distance := 250.0
@export var max_alive := 20  # cap on how many enemies may exist at once

@onready var mobs: Node = $"../Mobs"

func _on_timer_timeout() -> void:
	if enemy_scenes.is_empty() or mobs.get_child_count() >= max_alive:
		return

	var hero := get_tree().get_first_node_in_group("player") as Node2D
	if hero == null:
		return

	_spawn(hero)

func _spawn(hero: Node2D) -> void:
	var enemy: Node2D = enemy_scenes.pick_random().instantiate()
	enemy.global_position = hero.global_position + _spawn_offset()
	mobs.add_child(enemy)

func _spawn_offset() -> Vector2:
	var angle := randf_range(0.0, TAU)
	var dist := randf_range(min_spawn_distance, max_spawn_distance)
	return Vector2.from_angle(angle) * dist
