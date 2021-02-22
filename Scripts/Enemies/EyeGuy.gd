extends Enemy

enum {
    IDLE,
    SEEK,
    CHASE,
    ATTACK,
    ATTACKING,
    DYING
}

export var attack_dmg : int = 1
export var attack_rate : float = 1.0
export var attack_dist : int = 80

export var move_speed : int = 150

var state = IDLE
var seeking_direction : Vector2 = Vector2.ZERO

onready var enemy_body = $Body
onready var sprite = $Body/Sprite
onready var sight = $Body/Sight
onready var attack_cooldown = $AttackCooldown

func _ready():
    attack_cooldown.wait_time = attack_rate
    anim.play("IdleSight")

func _physics_process ( delta ):
        
    match state:
        IDLE:
            look_around()
        SEEK:
            seek_player( delta )
            continue
        CHASE:
            chase_state()
            continue
        ATTACK:
            attack_state()

func look_around():
    if target != null:
        state = CHASE
    else:
        play_animation ( "Idle" )
    
func seek_player ( delta ):
    var col = enemy_body.move_and_collide ( seeking_direction * move_speed * delta )
    if col:
        var new_seek_dir = seeking_direction.bounce ( col.normal )
        var angle = new_seek_dir.angle_to ( seeking_direction )
        var new_rot = sight.transform.rotated ( -angle )
        seeking_direction = new_seek_dir
        sight.transform = new_rot
    play_animation ( "Chase" )

func chase_state():
    if target == null:
        state = IDLE
        return
    
    var dist = enemy_body.global_position.distance_to ( target.global_position )
    if dist > attack_dist:
        var vel = ( target.global_position - enemy_body.global_position ).normalized()
        vel = enemy_body.move_and_slide ( vel * move_speed )
        if vel == Vector2.ZERO:
            play_animation ( "Idle" )
        else:
            play_animation ( "Chase" )

    elif state != ATTACKING:
        state = ATTACK
    

func attack_state():
    if target == null:
        state = IDLE
    elif attack_cooldown.time_left == 0:
        play_animation ( "Idle" )
        attack_cooldown.start()

func track_bullet ( bullet ):
    if bullet.is_in_group ( "bullet" ):
        anim.stop()
        anim.seek(0.0, true)
        sight.rotation = bullet.rotation
        sight.rotation_degrees += 90
        seeking_direction = sight.transform.y.normalized()
        state = SEEK
            

func play_animation ( anim_name ):
    
    if sprite.animation != anim_name:
        sprite.play ( anim_name )


func _on_Sight_body_entered ( body ):
    if target == null && body.is_in_group ("player"):
        target = body
        state = CHASE
        sight.call_deferred("set", "disabled", true)
        sight.call_deferred("set", "visible", false)
        anim.stop()

func _on_Body_took_hit ( from, damage ):
    take_damage ( damage )
    if state == IDLE or state == SEEK:
        track_bullet ( from )

func _on_AttackCooldown_timeout():
    #start the attack animation
    var dist = enemy_body.global_position.distance_to ( target.global_position )
    if target and dist <= attack_dist:
        anim.play ( "Attack" )
        state = ATTACKING
    else:
        state = CHASE

func _on_Sprite_animation_finished():
    #deal damage to player after sprite attack is finished
    if sprite.animation == "Attack":
        if target:
            target.take_damage ( attack_dmg )
            state = CHASE
        else:
            state = IDLE

func _on_AnimationPlayer_animation_finished ( anim_name ):
    #after attack animation is finished switch to chase state
    if anim_name == "Attack":
        state = CHASE
