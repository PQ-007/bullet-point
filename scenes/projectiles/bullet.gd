extends Area2D
class_name Bullet

## Simple projectile: travels in a straight line, damages the first body it
## hits, and frees itself after a short lifetime. Collision layers keep it from
## hitting the hero who fired it (see bullet.tscn).

@export var speed: float = 900.0
@export var damage: int = 25
@export var life_time: float = 1.5
@export var radius: float = 1.6
@export var color: Color = Color(1.0, 0.95, 0.5)  # warm muzzle-flash yellow

var dir: Vector2 = Vector2.RIGHT

func _ready() -> void:
	get_tree().create_timer(life_time).timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)
	queue_redraw()

func _physics_process(delta: float) -> void:
	global_position += dir * speed * delta

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)

func _on_body_entered(body: Node) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage(damage)
	queue_free()
