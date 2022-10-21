extends Node2D

const SERVER_IP="localhost"
const PORT=1334

const Player = preload("res://scenes/player.tscn")

var enet: ENetMultiplayerPeer

@onready var players = $Players

# Called when the node enters the scene tree for the first time.
func _ready():
	if "--server" in OS.get_cmdline_args():
		start_as_host()
	if "--client" in OS.get_cmdline_args():
		start_as_client()

func start_as_host():
	$CanvasLayer/MainMenu.visible = false
	spawn_player()
	

func start_as_client():
	$CanvasLayer/MainMenu.visible = false
	spawn_player()


func spawn_player():
	var player = Player.instantiate()
	players.add_child(player)

func _on_host_button_pressed():
	start_as_host()


func _on_join_button_pressed():
	start_as_client()
