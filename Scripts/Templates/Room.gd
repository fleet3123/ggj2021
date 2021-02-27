extends Node2D

signal room_entered()
signal room_exited()

enum Direction{
    NORTH,
    EAST,
    SOUTH,
    WEST,
}

const ENUMTOSTRING = {
    Direction.NORTH: "North",
    Direction.EAST: "East",
    Direction.SOUTH: "South",
    Direction.WEST: "West"
    }
    
const PLAYERDICT = {
    Direction.NORTH: "South",
    Direction.EAST: "West",
    Direction.SOUTH: "North",
    Direction.WEST: "East"
    }
    
const OPPOSITE = {
    Direction.NORTH: Direction.SOUTH,
    Direction.EAST: Direction.WEST,
    Direction.SOUTH: Direction.NORTH,
    Direction.WEST: Direction.EAST
}
    
#const Direction = preload("res://Scripts/utils/direction.gd")
const PLAYERSTART = "PlayerStart_"
const ROOMSPAWN = "RoomSpawn_"
const CAMERAPOINT = "CameraPoint"


export (NodePath) var camera_path
export (NodePath) var player_path
export (NodePath) var encounter setget set_encounter

export (PackedScene) var room_north
export (PackedScene) var room_east
export (PackedScene) var room_south
export (PackedScene) var room_west

export (NodePath) var room_path_north
export (NodePath) var room_path_east
export (NodePath) var room_path_south
export (NodePath) var room_path_west

var _camera : Camera2D = null
var _exits : Dictionary = {}

onready var tween = $Tween


func _ready():
    _camera = get_node ( camera_path )
    _exits [ Direction.NORTH ] = [ room_path_north, room_north ]
    _exits [ Direction.EAST ] = [ room_path_east, room_east ]
    _exits [ Direction.SOUTH ] = [ room_path_south, room_south ]
    _exits [ Direction.WEST ] = [ room_path_west, room_west ]


func set_exit_room_path ( var direction, var path : NodePath ):
    _exits [ direction ] [0] = path
    match direction:
        Direction.NORTH:
            room_path_north = path
        Direction.EAST:
            room_path_east = path
        Direction.SOUTH:
            room_path_south = path
        Direction.WEST:
            room_path_west = path
 
            
func spawn_room ( direction ) -> Node2D :
    var next_room = _exits [ direction ][ 1 ]
    var room = next_room.instance()
    room.position = get_node ( ROOMSPAWN + ENUMTOSTRING [ direction ] ).global_position
    room.player_path = player_path
    room.camera_path = camera_path
        
    var parent = get_parent()
    parent.add_child ( room )
    set_exit_room_path ( direction, room.get_path() )
    room.set_exit_room_path ( OPPOSITE [ direction ], get_path() )
    
    return room

func enter_room ( player, direction ):
    var room = null
    var next_room_path = _exits [ direction ][ 0 ]
    
    if next_room_path:
        room = get_node ( next_room_path )
    else:
        room = spawn_room ( direction )

    tween.interpolate_property (
        _camera
        , "position"
        , _camera.position
        , room.get_node ( CAMERAPOINT ).global_position
        , 1
        , Tween.TRANS_QUAD , Tween.EASE_IN_OUT
        )
    tween.interpolate_property (
        player
        , "position"
        , player.position
        , room.get_node ( PLAYERSTART + PLAYERDICT [ direction ] ).global_position
        , 1
        , Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
        )
    tween.start()
    room.emit_signal ( "room_entered" )

func set_encounter ( new_encounter ):
    encounter = new_encounter


func _on_room_entered():
    if encounter:
        var e = get_node ( encounter )
        e.startEncounter()


func _on_Room_tree_entered():
    print ( self, " entered tree.")


func _on_exit_entered ( body, direction ):
    if body.is_in_group ( "player" ) and body.in_control == true:
        body.in_control = false
        call_deferred ( "enter_room", body, direction )


func _on_Tween_tween_completed ( object, key ):
    print (object, " ", key)
    if object.is_in_group("player"):
        object.in_control = true
