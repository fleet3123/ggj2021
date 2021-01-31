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

func _ready ():
    camera = get_parent().get_node ( get_parent().camera_path ) as Camera2D

func _on_Exit_body_entered ( body ):

    var parent = get_parent()
    var player = parent.get_node ( parent.player_path )
    if body == player:
#            get_tree().reload_current_scene()
        var room = null
        if next_room_path:
            room = parent.get_node ( next_room_path )
        else:
            room = next_room.instance()
            room.position = parent.get_node ( ROOMSPAWN + ENUMTOSTRING [ direction ] ).position
            room.player_path = parent.player_path
            room.camera_path = parent.camera_path
            
            parent.get_parent().add_child ( room )
            parent.set_exit_room_path ( direction, room.get_path() )
            room.set_exit_room_path ( OPPOSITE[direction], parent.get_path() )
#            match direction:
#                Direction.NORTH: 
#                    parent.room_path_north = room.get_path()
#                    room.room_path_south = parent.get_path()
#                Direction.EAST: 
#                    parent.room_path_east = room.get_path()
#                    room.room_path_west = parent.get_path()
#                Direction.SOUTH: 
#                    parent.room_path_south = room.get_path()
#                    room.room_path_north = parent.get_path()
#                Direction.WEST: 
#                    parent.room_path_west = room.get_path()
#                    room.room_path_east = parent.get_path()

        camera.position = room.get_node ( CAMERAPOINT ).global_position
        player.position = room.get_node ( PLAYERSTART + PLAYERDICT [ direction ] ).global_position


