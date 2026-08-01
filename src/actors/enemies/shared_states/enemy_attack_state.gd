extends State

@export var active_frame: int = 0
@export var recovery_frame: int = 3
@export var damage: int = 8
@export var knockback_force: float = 150.0

const HITBOX_OFFSET := Vector2(16, 0)  # base offset when facing right
const HITBOX_SIZE := Vector2(24, 14)

var attack_dir: Vector2 = Vector2.RIGHT

func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO

	var vec_to_player = actor.player.global_position - actor.global_position
	var move_dir = vec_to_player.normalized()
	actor.flip_sprite(move_dir)

	attack_dir = Vector2.LEFT if actor.flipped else Vector2.RIGHT

	actor.play_animation("attack")
	actor.animated_sprite.frame_changed.connect(_on_frame_changed)
	actor.animated_sprite.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

	# handle the case where the swing connects on the very first frame
	if active_frame == 0:
		_activate_hitbox()

func physics_update(_delta: float) -> void:
	pass  # enemy stays still during the swing

func _on_frame_changed() -> void:
	var frame = actor.animated_sprite.frame
	if frame == active_frame and active_frame != 0:
		_activate_hitbox()
	elif frame == recovery_frame:
		actor.hit_box.deactivate()

func _activate_hitbox() -> void:
	var offset = HITBOX_OFFSET
	if attack_dir == Vector2.LEFT:
		offset.x = -offset.x
	actor.hit_box.damage = damage
	actor.hit_box.knockback_force = knockback_force
	actor.hit_box.activate(offset, HITBOX_SIZE, attack_dir)

func _on_attack_finished() -> void:
	state_machine.transition_to("Chase")

func exit() -> void:
	actor.hit_box.deactivate()
	if actor.animated_sprite.frame_changed.is_connected(_on_frame_changed):
		actor.animated_sprite.frame_changed.disconnect(_on_frame_changed)
	if actor.animated_sprite.animation_finished.is_connected(_on_attack_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_attack_finished)
