extends KinematicBody2D

var curr_hp  = 5
var max_hp = 5

var vel
var speed = 100

onready var prepareAttack = $prepareAttack
onready var recover = $recover
onready var cooldownTimer = $cooldownTimer
var target = null
var attacking = false
var attack_dir = Vector2.ZERO
var jump_strength = 1500
export var jump_stop = 1.2
var jump = jump_strength
var preparing = false
var cooldown = false


enum {
	IDLE,
	CHASE,
	ATTACK,
	RECOVER
}

var state = IDLE

func _physics_process(delta):
	match state:
		IDLE:
			seek_player()
			
		CHASE:
			chase_state()
			
		ATTACK:
			attack_state()
		RECOVER:
			return


func chase_state():
	if target == null:
		state = IDLE
		return
		
	if $Attack.overlaps_body(target) and !cooldown:
		state = ATTACK
		
	var direction = (target.global_position - global_position).normalized()
	
	move_and_slide(direction*speed)
	

func _on_Detection_body_entered(body):
	target = body
	

func seek_player():
	if target != null:
		state = CHASE

func _on_Attack_body_entered(body):
	if state != RECOVER and !cooldown:
		state = ATTACK
	
func attack_state():
	
	if !preparing:
		attacking = false
		
		prepareAttack.start()
		preparing = true
		
		attack_dir = (target.global_position - global_position).normalized()
	
	if !attacking:
		return
	
	move_and_slide(attack_dir * jump)
	
	jump = jump/jump_stop
	if jump <= 1:
		jump = jump_strength
		
		state = RECOVER
		recover.start()
		cooldownTimer.start(2.5)
		cooldown = true
		preparing = false
		attacking = false
		



func _on_prepareAttack_timeout():
	prepareAttack.stop()
	attacking = true


func _on_recover_timeout():
	recover.stop()
	state = IDLE


func _on_cooldownTimer_timeout():
	cooldownTimer.stop()
	cooldown = false
	
