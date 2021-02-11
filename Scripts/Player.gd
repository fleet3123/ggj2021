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

export (PackedScene) var Bullet

onready var ray_cast = $RayCast2D
onready var anim = $AnimatedSprite

var in_control : bool = true

func _ready ():
    $AnimationPlayer.play ( "Idle" )

func _process ( _delta ):
    if not in_control:
        pass    
    elif Input.is_action_just_pressed ( "interact" ):
        try_interacting()

func _physics_process ( delta ):
    
    if not in_control:
        return
    
    vel = Vector2()

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

    # move the player
    vel = move_and_slide ( vel * move_speed )

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

func try_interacting ():
    ray_cast.cast_to = facing_dir * interact_dist
    shoot()

func take_damage ( dmg_to_take ):
    curr_hp -= dmg_to_take
    $AnimationPlayer.play ( "Attacked" , 1 )
    $AnimationPlayer.queue ( "Idle" )
    if curr_hp <= 0:
        die()

func die():
    get_tree().reload_current_scene()

func shoot ():
    $BulletSpawn.look_at ( get_global_mouse_position() )
    var b = Bullet.instance()
    owner.add_child(b)
    b.transform = $BulletSpawn.global_transform

func set_exit_collision ( var enable : bool ) :
    self.set_collision_layer_bit ( 2, enable )
