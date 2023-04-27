extends Node2D


@onready var host_join:Control = $CanvasLayer/HostJoin
@onready var address_entry:Control = $CanvasLayer/HostJoin/MarginContainer/VBoxContainer/Address

const PLAYER = preload("res://GameObjects/player_1.tscn")
const PORT:int = 9999
var enet_peer := ENetMultiplayerPeer.new()


func _unhandled_input(event)->void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_host_pressed():
	host_join.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())


func _on_join_pressed():
	host_join.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	


func add_player(peer_id:int)->void:
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
