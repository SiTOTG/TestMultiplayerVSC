extends Node2D

const Enemy = preload("res://scenes/enemy.tscn")

@export_node_path(Node2D) var players_path
@onready var players_parent = get_node(players_path)

@export_node_path(Node2D) var enemies_path
@onready var enemies_parent = get_node(enemies_path)

@export_range(600, 1500) var spawn_distance = 1000

func _on_timer_timeout():
	if not players_parent:
		return
	var players = players_parent.get_children()
	if len(players) == 0:
		return
	var player: Player = players[0]
	
	var enemy = Enemy.instantiate()
	enemy.target = player
	var origin: Vector2 = player.position
	var direction = Vector2.RIGHT.rotated(randf_range(0, 2*PI))
	enemy.position = origin + direction*spawn_distance
	enemies_parent.add_child(enemy)
