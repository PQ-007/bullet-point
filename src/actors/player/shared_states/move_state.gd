extends State

func physics_update(_delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if input_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
		return

	actor.play_animation("run_" + actor.get_dir_suffix(input_dir))
	actor.velocity = input_dir * actor.move_speed
