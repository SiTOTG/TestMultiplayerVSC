class_name Enemy
extends Area2D

const SPEED = 150
const AVOID_FORCE = 20

signal die

@export_range(1, 1000) var max_hp = 400
@export_range(0, 1000) var hp = 400:
	get:
		return hp
	set(value):
		if hp_bar:
			value = clampi(value, 0, max_hp)
			hp_bar.value = value
			hp = value
			if value == 0:
				die.emit()

@onready var player_detector: Area2D = $PlayerDetector
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var damage_cooldown: Timer = $DamageCooldown
@onready var hp_bar: ProgressBar = $HPBar

var target: Player

var velocity := Vector2.ZERO

func _ready():
	hp_bar.max_value = max_hp
	hp_bar.value = hp

func _physics_process(delta):
	var priority_target = _find_priority_target()
	if priority_target:
		var direction = position.direction_to(priority_target.position)
		velocity = direction * SPEED
		_avoid_other_enemies()
		position += velocity * delta
		
	_apply_damage_to_players()

func _avoid_other_enemies():
	for enemy in enemy_detector.get_overlapping_areas():
		enemy = enemy as Enemy
		if not enemy or enemy == self:
			continue
		velocity = velocity + (global_position - enemy.global_position).normalized()*AVOID_FORCE

func _apply_damage_to_players():
	if monitoring and has_overlapping_areas():
		var player_hurtboxes = get_overlapping_areas()
		for hurtbox in player_hurtboxes:
			hurtbox = hurtbox as Hurtbox
			if not hurtbox:
				printerr("Enemy colliding with something other than a hurtbox.")
				continue
			hurtbox.apply_damage(20)
			monitoring = false
			damage_cooldown.start()

func _find_priority_target():
	var priority_target = target

	var main_target_is_valid := target and is_instance_valid(target)
	if main_target_is_valid and player_detector.overlaps_body(target):
		return target

	var players_detected = player_detector.get_overlapping_bodies()
	if len(players_detected) == 0:
		if main_target_is_valid:
			return target
		else:
			return null

	var closest_player = _find_closest(players_detected)
	return closest_player

func _find_closest(players: Array) -> Player:
	var min_distance = null
	var closest_player = null
	for player in players:
		var distance = position.distance_to(player.position)
		if not min_distance or distance < min_distance:
			min_distance = distance
			closest_player = player
	return closest_player


func _on_damage_cooldown_timeout():
	monitoring = true

func apply_damage(damage: int):
	self.hp -= damage


func _on_die():
	if is_instance_valid(self) and multiplayer and multiplayer.is_server():
		queue_free()
