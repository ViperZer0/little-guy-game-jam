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
	var players = get_tree().get_nodes_in_group("players")
	if players.size() < 2:
		push_warning("Not enough players found to hug :c Proceeding without a hug...")
		players_collided.emit()
		return

	var player_1 = players[0]
	var player_2 = players[1]
	player_1.process = false
	player_2.process = false
	player_1.hug()
	player_2.hug()
	_align_players(player_1, player_2)

func _align_players(player_1: Player, player_2: Player) -> void:
	# Player 1s offset from their hug anchor
	var player_1_offset = -(player_1.global_position - player_1.hug_anchor.global_position)
	var player_2_offset = -(player_2.global_position - player_2.hug_anchor.global_position)
	var player_1_facing_right = player_1_offset.x < 0.0
	var player_2_facing_right = player_2_offset.x < 0.0
	# Flip player 2 around
	if player_1_facing_right == player_2_facing_right:
		player_2.flip_horiz(!player_2_facing_right)

	var hug_anchor_midpoint = (player_1.hug_anchor.global_position + player_2.hug_anchor.global_position) / 2
	var player_1_dest = hug_anchor_midpoint - player_1_offset
	# Rotate player_2 dest if the two players are facing the same direction.
	var player_2_dest = hug_anchor_midpoint - (player_2_offset.rotated(deg_to_rad(180) if player_1_facing_right == player_2_facing_right else 0))
	var p1_tween = get_tree().create_tween()
	var p2_tween = get_tree().create_tween()
	p1_tween.tween_property(player_1, "global_position", player_1_dest, 0.2)
	p2_tween.tween_property(player_2, "global_position", player_2_dest, 0.2)
	# Okay now we hide every child node except for the child lol, jfc.
	for child in owner.get_children():
		# Haha holy shit
		if child != player_1 and child != player_2 and child.name != "Background":
			var tween = get_tree().create_tween()
			tween.tween_property(child, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	await get_tree().create_tween().tween_interval(2).finished
	players_collided.emit()
