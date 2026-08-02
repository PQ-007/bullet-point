extends State

func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO
	actor.hit_box.deactivate()
	actor.hurt_box.set_deferred("monitorable", false)
	actor.play_animation("die")
	actor.animated_sprite.animation_finished.connect(_on_finished, CONNECT_ONE_SHOT)

func _on_finished() -> void:
	actor.queue_free()

func exit() -> void: pass
