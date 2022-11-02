class_name Player
extends CharacterBody2D

const SPEED = 300.0

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

@onready var camera = $Camera2D
@onready var hp_bar: ProgressBar = $HPBar
@onready var weapons = $Weapons


func _ready():
	set_multiplayer_authority(str(name).to_int())
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		camera.current = true

func _physics_process(delta):
	if str(multiplayer.get_unique_id()) == str(name):
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		if direction != Vector2.ZERO:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
		move_and_slide()

func _on_hurtbox_take_damage(damage):
	self.hp = self.hp - damage

func pickup(weapon_scene_file: String):
	if multiplayer and multiplayer.is_server():
		rpc.call("add_weapon", weapon_scene_file)

@rpc(call_local, reliable, any_peer)
func add_weapon(weapon_scene_file: String):
	var weapon_scene: PackedScene = load(weapon_scene_file)
	var weapon: Weapon = weapon_scene.instantiate() as Weapon
	if not weapon:
		return
	weapons.add_child(weapon, true)
