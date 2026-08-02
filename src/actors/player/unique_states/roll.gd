extends State

@export var roll_speed: float = 130.0
var roll_dir: Vector2 = Vector2.DOWN

func enter(params := {}) -> void:
	roll_dir = params.get("dir", roll_dir)
	actor.hurt_box.set_deferred("monitorable", false)
	actor.play_animation("roll", roll_dir)
	actor.animated_sprite.animation_finished.connect(_on_roll_finished, CONNECT_ONE_SHOT)

func physics_update(_delta: float) -> void:
	actor.velocity = roll_dir * roll_speed
	actor.move_and_slide()

func _on_roll_finished() -> void:
	state_machine.transition_to("Move")

func exit() -> void:
	actor.hurt_box.set_deferred("monitorable", true)
	if actor.animated_sprite.animation_finished.is_connected(_on_roll_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_roll_finished)
