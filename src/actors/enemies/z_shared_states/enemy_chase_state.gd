extends State
var move_dir = Vector2.DOWN
func enter(_msg := {}) -> void: pass

func physics_update(_delta: float) -> void: 
	var dist_to_player = actor.global_position.distance_to(actor.player.global_position)
	var vec_to_player = actor.player.global_position - actor.global_position
	move_dir = vec_to_player.normalized()
	actor.velocity = move_dir * actor.move_speed
	actor.flip_sprite(move_dir)
	actor.play_animation("move")
	
	
	if dist_to_player > actor.detect_range:
		state_machine.transition_to("Idle")
	elif dist_to_player <= actor.attack_range:
		state_machine.transition_to("Attack")
		

func exit() -> void: pass
