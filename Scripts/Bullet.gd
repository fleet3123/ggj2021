extends Area2D


var speed : int = 750
var damage : int = 1

func _physics_process ( delta ):
    position += transform.x * speed * delta

func _on_Bullet_body_entered ( body ):
    if body.is_in_group("player"):
        return
    elif body.is_in_group("hitable"):
        body.take_damage ( damage )
    queue_free()
