extends Node


@onready var host_join:Control = $CanvasLayer/HostJoin
@onready var address_entry:Control = $CanvasLayer/HostJoin/MarginContainer/VBoxContainer/Address

const PLAYER = preload("res://GameObjects/player_1.tscn")
const PORT:int = 9999
var address:String = ""
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
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()


func _on_join_pressed():
	host_join.hide()
	
	if not address.is_empty():
		var err:Error = enet_peer.create_client(address, PORT)
		if err != OK:
			print("can't connect to this ip address ",err)
	multiplayer.multiplayer_peer = enet_peer
	


func add_player(peer_id:int)->void:
	var player = PLAYER.instantiate()
	player.name = str(peer_id)
	add_child(player)
func remove_player(peer_id:int)->void:
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()


func _on_address_text_changed(new_text: String) -> void:
	address = new_text

func upnp_setup():
	var upnp := UPNP.new()
	var discover_result:int = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)
	
	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Failed To Discover Valid Gateway")
	
	var map_result:int = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Success! Join Address: %s" % upnp.query_external_address())
