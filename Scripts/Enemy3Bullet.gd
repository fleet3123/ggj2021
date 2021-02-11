extends Area2D


var dir = Vector2.ZERO
var speed = 400
var shot = false
var target = null

var damage = 1


func set_direction(direction):
#    dir = direction
    transform = direction
    
func set_position(pos):
    position = pos

func set_target(tar):
    target = tar

func shoot():
    $AnimatedSprite.play()
    shot = true

func _physics_process(delta):
    if shot:
        position += (speed * transform.x * delta)


func _on_Enemy3Bullet_body_entered(body):
    if body == target:
        target.take_damage(damage)
        queue_free()
    elif body.is_in_group ( "wall" ):
        entered_wall ( body )
    else:
        print ( "hit", body )
        
func entered_wall ( wall : Node2D ):
    
    var collision_test = Vector2.ZERO
    if ( wall.is_in_group ( "North" ) ):
        collision_test = Vector2.DOWN
    elif ( wall.is_in_group ( "East" ) ):
        collision_test = Vector2.LEFT
    elif ( wall.is_in_group ( "South" ) ):
        collision_test = Vector2.UP
    elif ( wall.is_in_group ( "West" ) ):
        collision_test = Vector2.RIGHT
    
    var dot = collision_test.dot ( transform.x )
    if dot <= 0 :
        queue_free()
