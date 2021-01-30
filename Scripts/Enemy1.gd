extends KinematicBody2D

var curr_hp : int = 5
var max_hp : int = 5

var move_speed : int = 150
export var xp_to_give : int = 30

var damage : int = 1
var attack_rate : float = 1.0
export var attack_dist : int = 80
export var chase_dist : int = 400

var facing_dir : Vector2 = Vector2()

export ( NodePath ) var player_path

onready var anim = get_node ( "AnimatedSprite" )
onready var timer = get_node ( "Timer" )
onready var target = get_node ( player_path )

func _ready():

    timer.wait_time = attack_rate
    timer.start()

func _on_Timer_timeout():

    if position.distance_to ( target.position ) <= attack_dist:
        target.take_damage ( damage )

func _physics_process ( delta ):

    var vel = Vector2.ZERO
    var dist = position.distance_to ( target.position )
    if dist > attack_dist and dist < chase_dist:

        vel = ( target.position - position ).normalized()
        move_and_slide ( vel * move_speed )

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
        var abs_x = abs ( vel.x )
        var abs_y = abs ( vel.y )
        if vel.x > 0 && abs_x >= abs_y:
            facing_dir = Vector2.RIGHT
            play_animation ( "MoveRight" )
        elif vel.x < 0 && abs_x >= abs_y:
            facing_dir = Vector2.LEFT
            play_animation ( "MoveLeft" )
        elif vel.y < 0 && abs_x <= abs_y:
            facing_dir = Vector2.UP
            play_animation ( "MoveUp" )
        elif vel.y > 0 && abs_x <= abs_y:
            facing_dir = Vector2.DOWN
            play_animation ( "MoveDown" )

func play_animation ( anim_name ):

    if anim.animation != anim_name:
        anim.play ( anim_name )

func take_damage ( dmg_to_take ):

    curr_hp -= dmg_to_take
    if curr_hp <= 0:
        die()

func die ():
    target.give_xp ( xp_to_give )
    queue_free()

