class_name Player
extends CharacterBody2D

const SPEED = 300.0

@onready var camera = $Camera2D

func _ready():
	set_multiplayer_authority(str(name).to_int())
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.current = true

func _physics_process(delta):
	if str(multiplayer.get_unique_id()) == str(name):
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		if direction != Vector2.ZERO:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO

		move_and_slide()
