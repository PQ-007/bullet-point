class_name StateMachine
extends Node

@export var initial_state: State
var current_state: State
var states = {}

func _ready() -> void:
	await owner.ready
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.actor = owner
			child.state_machine = self
	if initial_state:
		current_state = initial_state
		current_state.enter()
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
		
func transition_to(state_name: String, msg := {}):
	var key = state_name.to_lower()
	if not states.has(key):
		push_error("State байхгүй: " + state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[key]
	current_state.enter(msg)
	#print("→ ", state_name)  # debug-д амар, аль state рүү шилжиж байгааг харна
		
