extends Area2D

func _on_Exit_body_entered(body):
    if body == owner.get_node ( "Player" ):
            get_tree().reload_current_scene()
