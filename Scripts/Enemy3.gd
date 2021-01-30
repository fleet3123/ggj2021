extends KinematicBody2D

export (PackedScene) var Bullet2

onready var animation = $AnimatedSprite

var curr_hp = 3
var max_hp = 3

var xp_to_give = 20

var speed = 100

var target = null
var cooldown = false
onready var cooldownTimer = $cooldownTimer

var state = IDLE


enum {
	IDLE,
	CHASE,
	ATTACK
}



func _physics_process(delta):
	animation.play()
	match state:
		IDLE:
			seek_player()
		CHASE:
			chase_state()
		ATTACK:
			attack_state()
			
			
func seek_player():
	if target != null:
		state = CHASE
		
func chase_state():
	if target == null:
		state = IDLE
		return
	
		
	if $Attack.overlaps_body(target) and !cooldown:
		state = ATTACK

	var direction = (target.global_position - global_position).normalized()
	if direction.x > 0:
		if !animation.is_flipped_h():
			animation.set_flip_h(true)
			
	elif direction.x < 0:
		if animation.is_flipped_h():
			animation.set_flip_h(false)
			
		
	if $too_close.overlaps_body(target):
		move_and_slide((direction*(-1)) * (speed/2))
		
	elif !$Attack.overlaps_body(target):
		move_and_slide(direction*speed)

func attack_state():
	shoot()
	state = IDLE
	
func shoot():
	var b = Bullet2.instance()
	b.set_direction((target.global_position - global_position).normalized())
	b.shoot()
	b.set_position(global_position)
	b.set_target(target)
	owner.add_child(b)
	
	cooldown = true
	cooldownTimer.start(2)


func _on_cooldownTimer_timeout():
	cooldownTimer.stop()
	cooldown = false


func _on_Attack_body_entered(body):
	if !cooldown:
		state = ATTACK


func _on_Detection_body_entered(body):
	target = body
	
func take_damage(dmg_to_take):
	curr_hp -= dmg_to_take
	if curr_hp <= 0:
		die()
		
func die():
	target.give_xp(xp_to_give)
	queue_free()
