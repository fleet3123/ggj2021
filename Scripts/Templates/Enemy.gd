class_name Enemy
extends Node2D


signal spawned
signal hit
signal died

export ( int ) var starting_hp = 1
export ( int ) var xp_to_give = 0
export ( Script ) var behavior

var target : Object = null
var curr_hp : int = starting_hp

onready var anim = $AnimationPlayer

func _init():
    pass

func _ready ():
    curr_hp = starting_hp
    print ( "Enemy ready", self, anim)
    if anim.has_animation ( "Spawn" ):
        anim.play ( "Spawn" )
    # emit_signal ( "spawned" )

func take_damage ( dmg : int ):
    emit_signal ( "hit" )
    
    curr_hp -= dmg
    if curr_hp <= 0:
        die()

func die ():
    emit_signal ( "died" )
    if target:
        target.give_xp ( xp_to_give )
    
    if anim.has_animation ( "Die" ):
        anim.play ( "Die" )
    else:
        queue_free();

func _on_AnimationPlayer_animation_finished ( anim_name : String ):
    if anim_name == "Spawn":
        emit_signal ( "spawned" )
    elif anim_name == "Die":
        queue_free()
    
    

