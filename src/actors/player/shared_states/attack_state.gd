extends State

var combo_stage: int = 0
var combo_queued: bool = false
var facing_dir: Vector2 = Vector2.DOWN

const STAGE_DATA := {
	2: {
		"anim": "attack",
		"damage": 15,
		"configs": {
			"down":  {"offset": Vector2(0, 7),  "size": Vector2(38, 36), "active": 2, "recovery": 5},
			"top":   {"offset": Vector2(-0.5, -11.5), "size": Vector2(37, 35), "active": 2, "recovery": 4},
			"right": {"offset": Vector2(14, 4),   "size": Vector2(58, 16), "active": 0, "recovery": 4},
		}
	},
	1: {
		"anim": "chop",
		"damage": 10,
		"configs": {
			"down":  {"offset": Vector2(-10, 10),  "size": Vector2(20, 38), "active": 0, "recovery": 2},
			"top":   {"offset": Vector2(6.5, -18.5), "size": Vector2(19, 33), "active": 0, "recovery": 2},
			"right": {"offset": Vector2(12.5, -6),   "size": Vector2(44, 16), "active": 0, "recovery": 2},
		}
	},
}

const DIR_VECTORS := {
	"down": Vector2.DOWN,
	"top": Vector2.UP,
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
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
	var config = _get_config(combo_stage)
	if config["active"] == 0:
		_activate_hitbox(data, config)

func physics_update(_delta: float) -> void:
	if combo_stage == 1 and Input.is_action_just_pressed("attack"):
		combo_queued = true

func _get_config(stage: int) -> Dictionary:
	var configs = STAGE_DATA[stage]["configs"]
	var key = actor.last_dir
	if key == "lr":
		key = "right"
	var config = configs[key].duplicate()
	if actor.last_dir == "lr" and actor.flipped:
		config["offset"] = Vector2(-config["offset"].x-3, config["offset"].y)
	return config

func _activate_hitbox(data: Dictionary, config: Dictionary) -> void:
	var dir_key = actor.last_dir
	if dir_key == "lr":
		dir_key = "left" if actor.flipped else "right"
	actor.hit_box.damage = data["damage"]
	actor.hit_box.activate(config["offset"], config["size"], DIR_VECTORS[dir_key])

func _on_frame_changed() -> void:
	var data = STAGE_DATA[combo_stage]
	if not actor.animated_sprite.animation.begins_with(data["anim"]):
		return
	var config = _get_config(combo_stage)
	var frame = actor.animated_sprite.frame
	if frame == config["active"]:
		_activate_hitbox(data, config)
	elif frame == config["recovery"]:
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
