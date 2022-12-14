extends Weapon

const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")

@onready var enemy_detector: Area2D = $EnemyDetector


func _on_bullet_cooldown_timer_timeout():
	if not multiplayer or not multiplayer.is_server():
		return
	var overlap = enemy_detector.get_overlapping_areas()
	if len(overlap) > 0:
		var target: Enemy = overlap[0]
		var bullet = bullet_scene.instantiate()
		bullet.target = target
		bullet.global_position = global_position
		bullet.damage = damage
		Projectiles.add_child(bullet, true)
