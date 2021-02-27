extends Area2D

signal exit_entered ( body, direction )

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
    emit_signal ( "exit_entered", body, direction )
