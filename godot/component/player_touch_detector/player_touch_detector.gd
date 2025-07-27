## This component finds all the players in a scene and detects for when they touch each other.
##
## In theory there should only ever be two players, and it doesn't matter which one we listen for since they'll just touch each other.
class_name PlayerTouchDetector extends Node

signal players_collided()

func _ready():
	# Call this function after the scene tree has fully constructed.
	# Otherwise the order in which this node was loaded compared to the players would matter.
	_after_ready.call_deferred()

func _after_ready() -> void:
	# We somewhat arbitrarily pick the first player
	var players = get_tree().get_nodes_in_group("players")
	if players.is_empty():
		push_warning("No nodes found in group 'player'. This PlayerTouchDetector will do nothing.")
		return

	var player: Player = get_tree().get_nodes_in_group("players")[0] as Player
	player.players_collided.connect(_on_players_collided)

func _on_players_collided():
	print("Players touched!")
	players_collided.emit()
