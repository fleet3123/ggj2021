extends Node2D

signal room_spawned ( room )

const Direction = preload("res://Scripts/utils/direction.gd")
const PLAYERSTART = "PlayerStart_"
const ROOMSPAWN = "RoomSpawn_"
const CAMERAPOINT = "CameraPoint"

export (NodePath) var camera_path

var room_list : Dictionary = {}

var _camera : Camera2D = null
var _current_room : Node2D = null

onready var tween = $Tween

func _ready():
    _camera = get_node ( camera_path )

    var room1 = get_child ( 0 )
#    if room1 is Room:
    room_list [ room1 ] = [ 0, 0 ]
    _current_room = room1
    print ( "room_list", room_list )

func spawn_room ( room, in_dir ):
    var next_room = room.get_exit_scene ( in_dir )
    var spawned_room = next_room.instance()
    self.add_child ( spawned_room )
    
    spawned_room.connect ( "room_exited", self, "_on_room_exited")
    var room_pos = room.get_exit_room_spawn ( in_dir ) 
    spawned_room.position = room_pos.global_position

    room.set_exit_room_path ( in_dir, spawned_room.get_path() )
    spawned_room.set_exit_room_path ( Direction.OPPOSITE [ in_dir ], room.get_path() )
    
    var coords = room_list [ room ]
    var next_coords = Direction.ENUMTOARRAY [ in_dir ]
    room_list [ spawned_room ] = [ 
            coords [ 0 ] + next_coords [ 0 ]
            , coords [ 1 ] + next_coords [ 1 ] 
            ]
    
    emit_signal ( "room_spawned", spawned_room )
    return spawned_room

func exit_room ( player, room, direction ):
    
    var next_room_path = room.get_exit_path ( direction )
    var next_room = null
    if next_room_path:
        next_room = get_node ( next_room_path )
    else:
        next_room = spawn_room ( room, direction )
        #next_room = room.spawn_room ( direction )
                
    print ( "room_list", room_list )
    _move ( player, next_room, direction )
    _current_room = next_room

func _on_room_exited(player, room, direction):
    if player.in_control:
        player.in_control = false
        call_deferred ( "exit_room", player, room, direction )


func _on_Tween_tween_completed(object, key):
    print (object, " ", key)
    if object.is_in_group("player"):
        object.in_control = true
        
    if _current_room:
        _current_room.emit_signal ( "room_entered" )


func _move ( player, to_room, from ):
    tween.interpolate_property (
        _camera
        , "position"
        , _camera.position
        , to_room.get_node ( CAMERAPOINT ).global_position
        , 1
        , Tween.TRANS_QUAD , Tween.EASE_IN_OUT
        )
    tween.interpolate_property (
        player
        , "position"
        , player.position
        , to_room.get_node ( PLAYERSTART + Direction.PLAYERDICT [ from ] ).global_position
        , 1
        , Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
        )
    tween.start()
    

