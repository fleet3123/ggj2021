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


onready var exit_north = $Exit_North
onready var exit_east = $Exit_East
onready var exit_south = $Exit_South
onready var exit_west = $Exit_West

func _ready():
    exit_north.next_room = room_north
    exit_north.next_room_path = room_path_north
    
    exit_east.next_room = room_east
    exit_east.next_room_path = room_path_east
    
    exit_south.next_room = room_south
    exit_south.next_room_path = room_path_south
    
    exit_west.next_room = room_west
    exit_west.next_room_path = room_path_west


func set_exit_room_path ( var direction, var path : NodePath ):
    match direction:
        Direction.NORTH:
            room_path_north = path
            exit_north.next_room_path = room_path_north
        Direction.EAST:
            room_path_east = path
            exit_east.next_room_path = room_path_east
        Direction.SOUTH:
            room_path_south = path
            exit_south.next_room_path = room_path_south
        Direction.WEST:
            room_path_west = path
            exit_west.next_room_path = room_path_west


func set_encounter ( new_encounter ):
    encounter = new_encounter


func _on_room_entered():
    if encounter:
        var e = get_node ( encounter )
        e.startEncounter()


func _on_Room_tree_entered():
    pass # Replace with function body.
