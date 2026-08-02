extends State

func enter(_msg := {}) -> void:
	actor.velocity = Vector2.ZERO
	
func physics_update(_delta: float) -> void: 
	var dist_to_player = actor.global_position.distance_to(actor.player.global_position)
	actor.play_animation("idle")
	if dist_to_player <= actor.detect_range:
		state_machine.transition_to("Chase")
		
func exit() -> void: pass
