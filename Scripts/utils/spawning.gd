class_name Encounter
extends Node
# what i need 
# list of enemies
# list of spawn locationgs
# list of active spawns

signal encounter_started ( index )
signal encounter_ended ( index )
signal encounters_started()
signal encounters_ended()

export ( Array, NodePath ) var spawn_positions

export ( Array, Array ) var encounters
var active_spawns : Array = []
var spawn_count : int = 0
var active_encounter_idx : int = 0
var encounter_running : bool = false

var spawn_parent : Node2D = null setget set_spawn_parent, get_spawn_parent


onready var next_encounter = $NextEncounterCoolDown
# what is an encounter?
# a list of enemies to spawn ( multiple for timed encounters )
# the encounter ends when all enemies are dead

# What are my constraints?
# Number of Enemies in Encounter
# Number of spawn positions
# possible overlaps?
func startEncounters():
    
    if active_encounter_idx < encounters.size():
        emit_signal ( "encounters_started" )
        _startEncounter()  


func _startEncounter ():
    
    if encounter_running:
        return
    else:
        encounter_running = true

    var active_encounter = encounters [ active_encounter_idx ]
    
    if active_encounter.size() > spawn_positions.size() :
        spawn_count = spawn_positions.size()
    else:
        spawn_count = active_encounter.size()
    
    #first draft, just iterate spawn positions and spawn an enemy at each pos
    for idx in spawn_count:
        var spawn_at = spawn_positions [ idx ]
        var enemy = active_encounter [ idx ]
        var e = enemy.instance()
        e.connect ( "died", self, "_on_Enemy_died" )
        if spawn_parent:
            spawn_parent.add_child ( e )
        else:
            owner.add_child ( e )
        e.global_position = spawn_at.global_position
    

    emit_signal("encounter_started", active_encounter_idx )

func set_spawn_parent ( new_spawn_parent : Node2D ):
    spawn_parent = new_spawn_parent

func get_spawn_parent () -> Node2D:
    return spawn_parent

func _on_Enemy_died ():
    
    if spawn_count > 1:
        spawn_count -= 1
        
    elif active_encounter_idx < ( encounters.size() - 1 ) :
        emit_signal ( "encounter_ended", active_encounter_idx )
        encounter_running = false
        active_encounter_idx += 1
        next_encounter.start ( 1 )
        
    else:
        emit_signal ( "encounters_ended" )


func _on_NextEncounterCoolDown_timeout():
    _startEncounter ()
