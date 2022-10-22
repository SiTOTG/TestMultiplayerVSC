extends Area2D

const SPEED = 150

var target: Player

var velocity := Vector2.ZERO

func _physics_process(delta):
	if target:
		var direction = position.direction_to(target.position)
		velocity = direction * SPEED

		position += velocity * delta
