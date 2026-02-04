extends Node

@export var guard_scene: PackedScene = preload("res://scenes/enemies/guard.tscn")

@onready var hero: Node2D = $"../Hero"

@export var min_spawn_distance := 100.0
@export var max_spawn_distance := 250.0
@export var max_spawned_unit := 20
var spawned_unit := 0
func get_spawn_offset() -> Vector2:
	var angle := randf_range(0.0, TAU)
	var dist := randf_range(min_spawn_distance, max_spawn_distance)
	return Vector2.from_angle(angle) * dist

func spawn():
	var enemy: Node2D = guard_scene.instantiate()
	enemy.global_position = hero.global_position + get_spawn_offset()
	$"../Mobs".add_child(enemy)

func _on_timer_timeout():
	if spawned_unit < max_spawned_unit:
		spawned_unit+=1
		spawn()
