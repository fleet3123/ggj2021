extends Node


signal map_drop_picked_up()


# Called when the node enters the scene tree for the first time.
func _ready():
    $AnimationPlayer.play ( "Default" )
    $AnimationPlayer.queue ( "Default" )
    var root = get_tree().current_scene
    self.connect ( "map_drop_picked_up", root, "_on_map_drop_picked_up" )


func _on_MapDrop_body_entered(body):
    if body.is_in_group ( "player" ):
        emit_signal ( "map_drop_picked_up" )
        queue_free()
