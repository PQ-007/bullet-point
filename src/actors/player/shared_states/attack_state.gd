extends State

var combo_stage: int = 0       # 1 = attack, 2 = chop
var combo_queued: bool = false
var facing_dir: Vector2 = Vector2.DOWN

func enter(params := {}) -> void:
	facing_dir = params.get("dir", facing_dir)
	combo_stage = 1
	combo_queued = false
	actor.velocity = Vector2.ZERO
	_play_stage()

func _play_stage() -> void:
	var anim_name := "attack" if combo_stage == 1 else "chop"
	actor.play_animation(anim_name, facing_dir)
	actor.animated_sprite.animation_finished.connect(_on_stage_finished, CONNECT_ONE_SHOT)

func physics_update(_delta: float) -> void:
	# lock movement during the swing; drop this line if you want slight drift
	actor.move_and_slide()

	if combo_stage == 1 and Input.is_action_just_pressed("attack"):
		combo_queued = true

func _on_stage_finished() -> void:
	if combo_stage == 1 and combo_queued:
		combo_stage = 2
		combo_queued = false
		_play_stage()
	else:
		state_machine.transition_to("Idle")

func exit() -> void:
	if actor.animated_sprite.animation_finished.is_connected(_on_stage_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_stage_finished)
