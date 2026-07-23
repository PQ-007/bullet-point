class_name State
extends Node

var actor
var state_machine: StateMachine

func enter(_msg := {}) -> void: pass
func exit() -> void: pass
func physics_update(_delta: float) -> void: pass
