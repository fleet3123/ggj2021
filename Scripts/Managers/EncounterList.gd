extends Node

export (NodePath) var actor_spawn_path

var encounters : Array = []
var rng = RandomNumberGenerator.new()

func _ready():
    var actor_node = get_node_or_null ( actor_spawn_path )

    for e in get_children():
        encounters.append ( e )
        print ( "encounterlist owner is", owner.name)
        e.owner = owner
        print ( "encounter owner is", e.owner.name )
        e.spawn_parent = actor_node
        

func _on_room_spawned ( room ):
    rng.randomize()
    var random_index = rng.randi_range ( 0 , encounters.size() - 1 )
    
    room.encounter = encounters [ random_index ]
    room.encounter.connect ( "encounter_started", owner, "_on_encounter_started")
    room.encounter.connect ( "encounters_ended", owner, "_on_fight_ended" )
