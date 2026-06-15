extends Node2D
class_name HealthBar

## Lightweight world-space health bar drawn directly with _draw().
## Attach as a child of any unit and call set_health() when its health changes.

@export var bar_size: Vector2 = Vector2(22.0, 3.0)
@export var background_color: Color = Color(0.0, 0.0, 0.0, 0.6)
@export var fill_color: Color = Color(0.85, 0.2, 0.2)
@export var border_color: Color = Color(0.0, 0.0, 0.0, 0.8)
@export var hide_when_full := true

var _ratio: float = 1.0

func _ready() -> void:
	if hide_when_full:
		visible = false

func set_health(current: float, maximum: float) -> void:
	_ratio = clampf(current / maximum, 0.0, 1.0) if maximum > 0.0 else 0.0
	visible = not (hide_when_full and _ratio >= 1.0)
	queue_redraw()

func _draw() -> void:
	var origin := Vector2(-bar_size.x * 0.5, 0.0)
	var bg := Rect2(origin, bar_size)
	draw_rect(bg, background_color, true)
	draw_rect(Rect2(origin, Vector2(bar_size.x * _ratio, bar_size.y)), fill_color, true)
	draw_rect(bg, border_color, false, 1.0)
