extends KinematicBody2D

var curr_hp : int = 10
var max_hp : int = 10
var move_speed : int = 250
var damage : int = 1

var gold : int = 0

var curr_lvl : int = 1
var curr_xp : int = 0
var xp_to_next_lvl : int = 50
var xp_to_lvl_increas_rate : float = 1.2

var interact_dist : int = 70

var vel : Vector2 = Vector2()
var facing_dir : Vector2 = Vector2()

onready var ray_cast = $RayCast2D
onready var anim = $AnimatedSprite

func _physics_process ( delta ):
    vel = Vector2()

#    get_viewport().get_mouse_position()

    facing_dir = position.direction_to ( get_global_mouse_position() )
#    facing_dir.normalized()
    var abs_x = abs ( facing_dir.x )
    var abs_y = abs ( facing_dir.y )
    if facing_dir.x > 0 && abs_x >= abs_y:
        facing_dir = Vector2.RIGHT
    elif facing_dir.x < 0 && abs_x >= abs_y:
        facing_dir = Vector2.LEFT
    elif facing_dir.y < 0 && abs_x <= abs_y:
        facing_dir = Vector2.UP
    elif facing_dir.y > 0 && abs_x <= abs_y:
        facing_dir = Vector2.DOWN
    #inputs
    if Input.is_action_pressed ( "move_up" ):
        vel.y -= 1
#        facing_dir = Vector2.UP
    if Input.is_action_pressed ( "move_down" ):
        vel.y += 1
#        facing_dir = Vector2.DOWN
    if Input.is_action_pressed ( "move_left" ):
        vel.x -= 1
#        facing_dir = Vector2.LEFT
    if Input.is_action_pressed ( "move_right" ):
        vel.x += 1
#        facing_dir = Vector2.RIGHT

    vel = vel.normalized()

    if ( vel == Vector2.ZERO && Input.is_action_pressed ( "interact" ) ):
        play_animation ( "Interact" )
    else:
        # move the player
        move_and_slide ( vel * move_speed )

        manage_animations()

func manage_animations ():

    var dir = ""
    if facing_dir.x == 1:
        dir = "Right"
    elif facing_dir.x == -1:
        dir = "Left"
    elif facing_dir.y == 1:
        dir = "Down"
    elif facing_dir.y == -1:
        dir = "Up"

    if ( vel == Vector2.ZERO ):
        play_animation ( "Idle" + dir )
    else:
        play_animation ( "Move" + dir )


func play_animation ( anim_name ):
    if anim.animation != anim_name:
        anim.play ( anim_name )

func give_xp ( amount ):
    curr_xp += amount

    if curr_xp >= xp_to_next_lvl:
        level_up()

func level_up ():

    var overflow_xp = curr_xp - xp_to_next_lvl
    xp_to_next_lvl *= xp_to_lvl_increas_rate
    curr_xp = overflow_xp
    curr_lvl += 1

func take_damage ( dmg_to_take ):
    curr_hp -= dmg_to_take

    if curr_hp <= 0:
        die()

func die():
    get_tree().reload_current_scene()

