extends Area2D

var dir = Vector2.ZERO
var speed = 400
var shot = false
var target = null

var damage = 1

func set_direction(direction):
	dir = direction
	
func set_position(pos):
	position = pos

func set_target(tar):
	target = tar

func shoot():
	shot = true

func _physics_process(delta):
	if shot:
		position += (speed * dir * delta)


func _on_Enemy3Bullet_body_entered(body):
	if body == target:
		target.take_damage(damage)
	queue_free()
