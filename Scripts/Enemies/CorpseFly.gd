class_name CorpseFly
extends Enemy

enum {
    IDLE,
    CHASE,
    ATTACK
}

export (PackedScene) var Bullet

var speed = 100
var state = IDLE

var cooldown = false

onready var enemy_body = $Body
onready var sprite = $Body/AnimatedSprite
onready var bullet_spawn = $Body/AnimatedSprite/BulletSpawn
onready var attack_radius = $Body/Attack
onready var attack_cooldown = $AttackCooldown
onready var too_close_radius = $Body/TooClose

func _physics_process ( _delta ):
    match state:
        IDLE:
            seek_player()
            continue
        CHASE:
            chase_state()
            continue
        ATTACK:
            attack_state()  

func seek_player():
    if target != null:
        state = CHASE
        
func chase_state():
    if target == null:
        state = IDLE
        return

    if attack_radius.overlaps_body(target) and !cooldown:
        state = ATTACK

    var direction = (target.global_position - global_position).normalized()
#    direction = direction.normalized()

    if direction.x > 0 and !sprite.is_flipped_h():
        sprite.set_flip_h ( true )
        bullet_spawn.position.x *= -1
            
    elif direction.x < 0 and sprite.is_flipped_h():
        sprite.set_flip_h ( false )
        bullet_spawn.position.x *= -1
    
    var vel = Vector2.ZERO
    if too_close_radius.overlaps_body ( target ):
        vel = ( direction * (-1) ) * ( speed / 2 )
        
    elif !attack_radius.overlaps_body ( target ):
        vel = direction * speed
    
    enemy_body.move_and_slide ( vel )

func attack_state():
    if target != null:
        shoot()
        state = IDLE

func shoot():
    var b = Bullet.instance()
    
    bullet_spawn.look_at ( target.global_position )
    b.set_direction ( bullet_spawn.get_global_transform() )
        
    b.set_target ( target )
    if owner == null:
        owner = get_parent().owner
    owner.add_child ( b )
    b.shoot()
    
    cooldown = true
    attack_cooldown.start ( 2 )

func _on_Detection_body_entered ( body ):
    if body.is_in_group ( "player" ):
        target = body
    
func _on_Attack_body_entered ( _body ):
    if !cooldown:
        state = ATTACK

func _on_AttackCooldown_timeout():
    attack_cooldown.stop()
    cooldown = false

func _on_Body_took_hit ( _from, damage ):
    take_damage ( damage )
