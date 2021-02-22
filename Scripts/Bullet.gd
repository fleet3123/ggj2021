extends Area2D


var speed : int = 750
var damage : int = 1

onready var collision = $CollisionShape2D
onready var animation = $AnimationPlayer
func _physics_process ( delta ):
    position += transform.x * speed * delta

func _on_Bullet_body_entered ( body ):

    if body.is_in_group("hitable"):
        body.take_hit ( self, damage )
    die()

func die ():
    speed = 0
    collision.call_deferred ( "set", "disabled", true )
    animation.play ( "Hit" )

func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Hit":
        queue_free()
