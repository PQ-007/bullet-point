extends State

func enter(_msg := {}):
	actor.velocity = Vector2.ZERO
	

func physics_update(_delta):
	var input_dir = Input.get_vector("move_left","move_right","move_up", "move_down")
	actor.play_animation("idle", input_dir)
	if input_dir != Vector2.ZERO:
		state_machine.transition_to("Move")
		return
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack", {"dir": input_dir})
		return
	
	
