extends Node2D

const SERVER_IP="localhost"
const PORT=1334

const Player = preload("res://scenes/player.tscn")

var enet: ENetMultiplayerPeer

@onready var players = $Players

func _ready():
	if "--server" in OS.get_cmdline_args() or "--server-only" in OS.get_cmdline_args():
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
	enet.peer_disconnected.connect(
		func(id):
			for player in players.get_children():
				if str(player.name) == str(id):
					players.remove_child(player)
					_reassign_targets_targeting_player(player)
					player.queue_free()
					return
	)
	
	if not "--server-only" in OS.get_cmdline_args():
		do_spawn_player("1", 1)

func _reassign_targets_targeting_player(player):
	for enemy in $Enemies.get_children():
		if enemy is Enemy and enemy.target == player:
			var new_player = players.get_child(randi_range(0, players.get_child_count()-1))
			enemy.target = new_player

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
	player.position.x += randi_range(-10, 10)
	player.position.y += randi_range(-10, 10)
	player.name = StringName(pname)
	players.add_child(player)
	

func _on_host_button_pressed():
	start_as_host()


func _on_join_button_pressed():
	start_as_client()


func _on_multiplayer_spawner_spawned(node):
	print("Spawned new node...")
