extends Actor

enum {
	MOVE,
	ATTACK,
}


var state = MOVE


func _physics_process(delta):
	match state:
		
		MOVE:
			move_state(delta)
			
		ATTACK:
			pass
			
			

func move_state(delta):
	
	_velocity = get_direction()
	_velocity *= speed
	
	
	_velocity = move_and_slide(_velocity)


func get_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
