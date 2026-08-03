extends State

@export var arrow_scene: PackedScene
@export var shoot_frame: int = 4
@export var arrow_speed: float = 300.0
@export var damage: int = 6

const PULL_POSITIONS := {
	0: Vector2(6, -1),
	1: Vector2(3, 1),
	2: Vector2(0, 4),
}

var target_dir: Vector2 = Vector2.RIGHT
var carried_arrow: Arrow = null
var has_fired: bool = false

func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO
	has_fired = false

	target_dir = (actor.player.global_position - actor.global_position).normalized()
	actor.flip_sprite(target_dir)

	carried_arrow = arrow_scene.instantiate()
	actor.animated_sprite.add_child(carried_arrow)
	carried_arrow.position = _mirrored_pos(0)
	carried_arrow.rotation = -0.7854 if target_dir.x >= 0 else 0.7854
	carried_arrow.sprite.flip_h = target_dir.x < 0

	actor.play_animation("attack")
	actor.animated_sprite.frame_changed.connect(_on_frame_changed)
	actor.animated_sprite.animation_finished.connect(_on_finished, CONNECT_ONE_SHOT)

func _mirrored_pos(frame: int) -> Vector2:
	var pos = PULL_POSITIONS.get(frame, Vector2.ZERO)
	if target_dir.x < 0:
		return Vector2(-pos.x, pos.y)
	return pos

func _on_frame_changed() -> void:
	var frame = actor.animated_sprite.frame
	if not has_fired and PULL_POSITIONS.has(frame):
		carried_arrow.position = _mirrored_pos(frame)
	if frame == shoot_frame and not has_fired:
		_fire_arrow()

func _fire_arrow() -> void:
	has_fired = true
	var fire_dir = (actor.player.global_position - actor.global_position).normalized()
	carried_arrow.reparent(get_tree().current_scene)
	carried_arrow.global_position = actor.global_position
	carried_arrow.setup(fire_dir, arrow_speed, damage)
	carried_arrow = null

func _on_finished() -> void:
	state_machine.transition_to("Chase")

func exit() -> void:
	if actor.animated_sprite.frame_changed.is_connected(_on_frame_changed):
		actor.animated_sprite.frame_changed.disconnect(_on_frame_changed)
	if actor.animated_sprite.animation_finished.is_connected(_on_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_finished)
	if carried_arrow != null and is_instance_valid(carried_arrow):
		carried_arrow.queue_free()
		carried_arrow = null
