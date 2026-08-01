extends State

func enter(params := {}) -> void:
	actor.velocity = params.get("knockback", Vector2.ZERO)
	actor.play_animation("hurt")
	actor.animated_sprite.animation_finished.connect(_on_hurt_finished, CONNECT_ONE_SHOT)

func physics_update(delta: float) -> void:
	actor.velocity = actor.velocity.move_toward(Vector2.ZERO, 600 * delta)

func _on_hurt_finished() -> void:
	state_machine.transition_to("Chase")

func exit() -> void:
	if actor.animated_sprite.animation_finished.is_connected(_on_hurt_finished):
		actor.animated_sprite.animation_finished.disconnect(_on_hurt_finished)
