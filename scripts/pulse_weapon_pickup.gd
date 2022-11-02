extends Area2D

@export_file("*.tscn") var weapon_scene_file: String = "res://scenes/bullet_weapon.tscn"

func _on_body_entered(body: Player):
	body.pickup(weapon_scene_file)
	queue_free()
