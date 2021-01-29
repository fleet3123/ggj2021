extends KinematicBody2D

var curr_hp : int = 10
var max_hp : int = 10
var move_speed : int = 250
var damage : int = 1

var gold : int = 0
var curr_xp : int = 0
var xp_to_next_lvl : int = 50
var xp_to_lvl_increas_rate : float = 1.2

var interact_dist : int = 70

var vel : Vector2 = Vector2()
var facing_dir : Vector2 = Vector2()

onready var rayCast = get_node ( "RayCast2D" ) 
onready var anim = get_node("AnimatedSprite")

func _physics_process ( delta ):
	vel = Vector2()
	
	#inputs
	if Input.is_action_pressed ( "move_up" ):
		vel.y -= 1
		facing_dir = Vector2.UP
	if Input.is_action_pressed ( "move_down" ):
		vel.y += 1
		facing_dir = Vector2.DOWN
	if Input.is_action_pressed ( "move_left" ):
		vel.x -= 1
		facing_dir = Vector2.LEFT
	if Input.is_action_pressed ( "move_right" ):
		vel.x += 1
		facing_dir = Vector2.RIGHT
	
	vel = vel.normalized()
	
	if ( vel.length() == 0 && Input.is_action_pressed ( "interact" ) ):
		play_animation ( "Interact" )
	else:
		# move the player
		move_and_slide ( vel * move_speed )
	
		manage_animations()

func manage_animations ():

	if ( vel == Vector2.ZERO ):
		if facing_dir.x == 1:
			play_animation ( "IdleRight" )
		elif facing_dir.x == -1:
			play_animation ( "IdleLeft" )
		elif facing_dir.y == 1:
			play_animation ( "IdleUp" )
		elif facing_dir.y == -1:
			play_animation ( "IdleDown" )
	else:
		if vel.x > 0:
			play_animation ( "MoveRight" )
		elif vel.x < 0:
			play_animation ( "MoveLeft" )
		elif vel.y < 0:
			play_animation ( "MoveUp" )
		elif vel.y > 0:
			play_animation ( "MoveDown" )

func play_animation ( anim_name ):
	if anim.animation != anim_name:
		anim.play ( anim_name )
