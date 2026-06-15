extends CanvasLayer

## Screen-space UI: the hero's health bar and the "YOU DIED" overlay.
## Finds the hero through the "player" group and reacts to its signals.

@onready var health_bar: ProgressBar = $HealthBar
@onready var death_screen: Control = $DeathScreen

func _ready() -> void:
	death_screen.visible = false

	var hero := get_tree().get_first_node_in_group("player") as Hero
	if hero == null:
		return

	# Seed the bar now (the hero's first emit happens before this _ready runs).
	health_bar.max_value = hero.max_health
	health_bar.value = hero.health

	hero.health_changed.connect(_on_health_changed)
	hero.died.connect(_on_hero_died)

func _on_health_changed(current: float, maximum: float) -> void:
	health_bar.max_value = maximum
	health_bar.value = current

func _on_hero_died() -> void:
	death_screen.visible = true
