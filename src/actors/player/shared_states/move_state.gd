extends State
@export var walk_speed := 70.0
@export var run_speed := 90.0
func physics_update(_delta):
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var is_running := Input.is_action_pressed("run")
	if input_dir == Vector2.ZERO:
		state_machine.transition_to("Idle")
		return
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack", {"dir": input_dir})
		return

	if Input.is_action_just_pressed("roll"):
		state_machine.transition_to("Roll", {"dir": input_dir})
		return
	
	#if not is_running:
		#actor.velocity = input_dir * walk_speed
		#actor.play_animation("walk", input_dir)
	#else:
	actor.velocity = input_dir * run_speed
	actor.play_animation("run", input_dir)
	actor.move_and_slide()
