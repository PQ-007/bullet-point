extends Area2D
class_name Arrow

## Enemy projectile: flies in a straight line and damages the hero on contact.
## Collision layers (set in arrow.tscn) make it hit only the hero, passing over
## other enemies and player bullets.

@export var speed: float = 260.0
@export var damage: int = 8
@export var life_time: float = 3.0
@export var length: float = 10.0
@export var color: Color = Color(0.55, 0.35, 0.15)

var dir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	get_tree().create_timer(life_time).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta

func _draw() -> void:
	# Drawn pointing along local +x; the node's rotation aligns it to travel.
	var half := length * 0.5
	draw_line(Vector2(-half, 0.0), Vector2(half, 0.0), color, 1.5)
	draw_line(Vector2(half, 0.0), Vector2(half - 3.0, -2.0), color, 1.5)
	draw_line(Vector2(half, 0.0), Vector2(half - 3.0, 2.0), color, 1.5)

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
	queue_free()
