class_name Player
extends CharacterBody2D

const SPEED = 300.0

func _ready():
	set_multiplayer_authority(str(name).to_int())
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		$Camera2D.current = true

func _physics_process(delta):
	if str(multiplayer.get_unique_id()) == str(name):
		var direction = Vector2.ZERO
		direction.x = Input.get_axis("ui_left", "ui_right")
		direction.y = Input.get_axis("ui_up", "ui_down")

		if direction != Vector2.ZERO:
			velocity = direction.normalized() * SPEED
		else:
			velocity = direction

		move_and_slide()
