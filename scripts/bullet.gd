extends Area2D

@export var speed: int = 350

@onready var sprite: Sprite2D = $Sprite2D

var target: Enemy
var damage: int

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if is_instance_valid(target):
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed * delta
		sprite.look_at(target.global_position)
		global_position += velocity
	elif multiplayer and multiplayer.is_server():
		queue_free()

func _on_area_entered(area):
	if is_instance_valid(target) and target.has_method("apply_damage"):
		target.apply_damage(damage)
	
	if multiplayer and multiplayer.is_server():
		queue_free()
