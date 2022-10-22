extends Node2D

const SERVER_IP="localhost"
const PORT=1334

const Player = preload("res://scenes/player.tscn")

var enet: ENetMultiplayerPeer

@onready var players = $Players

func _ready():
	if "--server" in OS.get_cmdline_args():
		start_as_host()
	if "--client" in OS.get_cmdline_args():
		start_as_client()

func start_as_host():
	$CanvasLayer/MainMenu.visible = false
	enet = ENetMultiplayerPeer.new()
	enet.create_server(PORT)
	multiplayer.multiplayer_peer = enet
	enet.peer_connected.connect(
		func(id):
			print(id, " connected to the server")
	)

	do_spawn_player("1", 1)

func start_as_client():
	$CanvasLayer/MainMenu.visible = false
	enet = ENetMultiplayerPeer.new()
	enet.create_client(SERVER_IP, PORT)
	multiplayer.multiplayer_peer = enet
	enet.connection_succeeded.connect(
		func():
			print("Successfully connected to server")
			rpc_id(1, "spawn_player")
	)

@rpc(any_peer, reliable)
func spawn_player():
	var id = multiplayer.get_remote_sender_id()
	var pname = StringName(str(id))
	do_spawn_player(pname, id)

func do_spawn_player(pname: StringName, id: int):
	var player = Player.instantiate()
	player.name = StringName(pname)
	players.add_child(player)

func _on_host_button_pressed():
	start_as_host()


func _on_join_button_pressed():
	start_as_client()


func _on_multiplayer_spawner_spawned(node):
	print("Spawned new node...")
