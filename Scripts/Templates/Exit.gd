extends Area2D

signal exit_entered ( body, direction )

enum Direction {
    NORTH,
    EAST,
    SOUTH,
    WEST,
}

export (Direction)  var direction

func _ready ():
    pass
func _on_Exit_body_entered ( body ):
    emit_signal ( "exit_entered", body, direction )
