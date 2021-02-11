extends Area2D

enum Direction{
    NORTH,
    EAST,
    SOUTH,
    WEST,
}

const PLAYERSTART = "PlayerStart_"
const ROOMSPAWN = "RoomSpawn_"
const CAMERAPOINT = "CameraPoint"
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

export (Direction)  var direction

var next_room : PackedScene = null
var next_room_path : NodePath = ""
#export (PackedScene) var this_room

var camera : Camera2D = null
onready var tween = $Tween

func _ready ():
    camera = get_parent().get_node ( get_parent().camera_path ) as Camera2D

func _on_Exit_body_entered ( body ):

    var parent = get_parent()
    if body.is_in_group ( "player" ) and body.in_control == true:
#            get_tree().reload_current_scene()
        body.in_control = false
        var room = null
        if next_room_path:
            room = parent.get_node ( next_room_path )
        else:
            room = next_room.instance()
            room.position = parent.get_node ( ROOMSPAWN + ENUMTOSTRING [ direction ] ).global_position
            room.player_path = parent.player_path
            room.camera_path = parent.camera_path
            
            parent.get_parent().add_child ( room )
            parent.set_exit_room_path ( direction, room.get_path() )
            room.set_exit_room_path ( OPPOSITE[direction], parent.get_path() )

        tween.interpolate_property (
            camera
            , "position"
            , camera.position
            , room.get_node ( CAMERAPOINT ).global_position
            , 1
            , Tween.TRANS_QUAD , Tween.EASE_IN_OUT
            )
        tween.interpolate_property (
            body
            , "position"
            , body.position
            , room.get_node ( PLAYERSTART + PLAYERDICT [ direction ] ).global_position
            , 1
            , Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
            )
#        camera.position = room.get_node ( CAMERAPOINT ).global_position
#        player.position = room.get_node ( PLAYERSTART + PLAYERDICT [ direction ] ).global_position
#        player.set_exit_collision ( false )
        tween.start()

func _on_Tween_tween_completed(object, key):
    print (object, " ", key)
    if object.is_in_group("player"):
        print ( "is player" )
        object.in_control = true
#        player.set_exit_collision ( true )
