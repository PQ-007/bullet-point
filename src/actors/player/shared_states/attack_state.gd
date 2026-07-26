extends State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up", "move_down")
	actor.play_animation("idle", input_dir)
	
	if input_dir != Vector2.ZERO:
		state_machine.transition_to("Move")
		return
	#actor.play_animation("chop", input_dir)
	
	if Input.is_action_just_pressed("attack"):
		actor.play_animation("attack", input_dir)
	
