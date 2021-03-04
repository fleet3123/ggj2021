class_name Room    
extends Node2D

signal room_entered()
signal room_exited ( player, room, direction )


const Direction = preload("res://Scripts/utils/direction.gd")

var encounter : Encounter = null setget set_encounter, get_encounter

export (PackedScene) var room_north
export (PackedScene) var room_east
export (PackedScene) var room_south
export (PackedScene) var room_west

export (NodePath) var room_path_north
export (NodePath) var room_path_east
export (NodePath) var room_path_south
export (NodePath) var room_path_west

var exits : Dictionary = {}
var spawn_points : Array = []

onready var spawn_node = $SpawnPoints

func _ready():
    
    exits [ Direction.NORTH ] = [ room_path_north, room_north, $RoomSpawn_North ]
    exits [ Direction.EAST ] = [ room_path_east, room_east, $RoomSpawn_East ]
    exits [ Direction.SOUTH ] = [ room_path_south, room_south, $RoomSpawn_South ]
    exits [ Direction.WEST ] = [ room_path_west, room_west, $RoomSpawn_West ]
    
    for point in spawn_node.get_children():
        if point is Position2D:
            spawn_points.push_back ( point )
    
    if encounter:
        encounter.spawn_positions = spawn_points


func set_exit_room_path ( var direction, var path : NodePath ):
    exits [ direction ] [0] = path
    match direction:
        Direction.NORTH:
            room_path_north = path
        Direction.EAST:
            room_path_east = path
        Direction.SOUTH:
            room_path_south = path
        Direction.WEST:
            room_path_west = path


func get_exit_path ( var in_dir ) -> NodePath:
    return exits [ in_dir ][ 0 ]


func get_exit_scene ( var in_dir ) -> PackedScene:
    return exits [ in_dir ][ 1 ]


func get_exit_room_spawn ( var in_dir ) -> Position2D:
    return exits [ in_dir ][ 2 ]


func set_encounter ( new_encounter ):
    encounter = new_encounter.duplicate()
    self.add_child ( encounter )
    encounter.spawn_positions = spawn_points
    encounter.spawn_parent = new_encounter.spawn_parent

func get_encounter ():
    return encounter


func _on_room_entered():
    if encounter:
        encounter.startEncounter()


func _on_exit_entered ( body, direction ):
    if body.is_in_group ( "player" ):
        emit_signal ( "room_exited", body, self, direction )

