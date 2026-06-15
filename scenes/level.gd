extends Node2D

## Top-level gameplay scene. Restarts the run a short moment after the hero dies.

@export var restart_delay: float = 2.0

@onready var hero: Hero = $Hero

func _ready() -> void:
	hero.died.connect(_on_hero_died)

func _on_hero_died() -> void:
	await get_tree().create_timer(restart_delay).timeout
	get_tree().reload_current_scene()
