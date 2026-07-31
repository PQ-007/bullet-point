extends State

var combo_stage: int = 0
var combo_queued: bool = false
var facing_dir: Vector2 = Vector2.DOWN

const STAGE_DATA := {
	1: {"anim": "chop", "active_frame": 3, "recovery_frame": 5, "damage": 10},
	2: {"anim": "attack", "active_frame": 2, "recovery_frame": 4, "damage": 16},
}

func enter(params := {}) -> void:
	facing_dir = params.get("dir", facing_dir)
	combo_stage = 1
	combo_queued = false
	actor.velocity = Vector2.ZERO
	actor.animated_sprite.frame_changed.connect(_on_frame_changed)
	_play_stage()

func _play_stage() -> void:
	actor.hit_box.deactivate()
	var data = STAGE_DATA[combo_stage]
	actor.play_animation(data["anim"], facing_dir)
	actor.animated_sprite.animation_finished.connect(_on_stage_finished, CONNECT_ONE_SHOT)

func physics_update(_delta: float) -> void:
	if combo_stage == 1 and Input.is_action_just_pressed("attack"):
		combo_queued = true

func _on_frame_changed() -> void:
	var data = STAGE_DATA[combo_stage]
	if actor.animated_sprite.animation != data["anim"]:
		return
	var frame = actor.animated_sprite.frame
	if frame == data["active_frame"]:
		actor.hit_box.damage = data["damage"]
		actor.hit_box.activate(facing_dir)
	elif frame == data["recovery_frame"]:
		actor.hit_box.deactivate()

func _on_stage_finished() -> void:
	if combo_stage == 1 and combo_queued:
		combo_stage = 2
		combo_queued = false
		_play_stage()
	else:
		state_machine.transition_to("Idle")

func exit() -> void:
	actor.hit_box.deactivate()
	if actor.animated_sprite.animation_finished.is_connected(_on_stage_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_stage_finished)
	if actor.animated_sprite.frame_changed.is_connected(_on_frame_changed):
		actor.animated_sprite.frame_changed.disconnect(_on_frame_changed)
