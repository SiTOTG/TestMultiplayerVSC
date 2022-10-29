extends Weapon

@onready var target_detector: Area2D = $Area2D

func _on_damage_cooldown_timer_timeout():
	var targets = target_detector.get_overlapping_areas()
	for target in targets:
		if target.has_method("apply_damage"):
			target.apply_damage(damage)
