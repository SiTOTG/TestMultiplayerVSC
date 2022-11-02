extends Area2D

@export var speed: int = 350
@export var stray_time: int = 3

@onready var sprite: Sprite2D = $Sprite2D
@onready var stray_timer: Timer = $StrayTimer

var target: Enemy
var damage: int

var velocity: Vector2 = Vector2.ZERO

enum {
	CHASE,
	STRAY
}
var state: int = CHASE

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	if state == CHASE:
		_chase_mode(delta)
	else:
		_stray_mode(delta)

func _chase_mode(delta):
	if is_instance_valid(target):
		direction = global_position.direction_to(target.global_position)
		velocity = direction * speed * delta
		sprite.look_at(target.global_position)
		global_position += velocity
	elif multiplayer and multiplayer.is_server():
		state = STRAY

func _stray_mode(delta):
	if stray_timer.is_stopped():
		stray_timer.start(stray_time)
	velocity = direction * speed * delta
	global_position += velocity

func _on_area_entered(area):
	if is_instance_valid(area) and area.has_method("apply_damage"):
		area.apply_damage(damage)
	
	if multiplayer and multiplayer.is_server():
		queue_free()


func _on_stray_timer_timeout():
	queue_free()
