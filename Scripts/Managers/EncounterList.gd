extends Node

export (NodePath) var actor_spawn_path

var encounters : Array = []
var rng = RandomNumberGenerator.new()

func _ready():
    var actor_node = get_node_or_null ( actor_spawn_path )

    for e in get_children():
        encounters.append ( e )
        e.spawn_parent = actor_node

func _on_room_spawned ( room ):
    rng.randomize()
    var random_index = rng.randi_range ( 0 , encounters.size() - 1 )
    
    room.encounter = encounters [ random_index ]
