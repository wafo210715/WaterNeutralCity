class_name Card
extends Resource

enum Type {POLICY, TECH, EVENT}
enum TargetIssue {WATER_QUALITY, WATER_QUANTITY, BOTH, NULL}
enum Season {SPRING, SUMMER, AUTUMN, WINTER, SAME}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target_issue: TargetIssue
@export var funding: int
@export var favorite_season: Season
@export var water_quality: int
@export var water_quantity: int
@export var popularity: int

@export_group("Card Visual")
@export var image: Texture
@export_multiline var tooltip_text: String


func issue_is_water_quality() -> bool:
	return target_issue == TargetIssue.WATER_QUALITY


func issue_is_water_quantity() -> bool:
	return target_issue == TargetIssue.WATER_QUANTITY




func play(targets: Array[Node], player_stats: PlayerStats) -> bool:
	print("Card: Play function called for card ID:", id)
	Events.card_played.emit(self)

	if player_stats.funding + funding < 0:
		print("Insufficient funding for card ID:", id)
		return false

	player_stats.funding += funding
	print("Funding updated for card ID:", id, "New funding:", player_stats.funding)

	var tree := targets[0].get_tree()
	var area1_nodes = tree.get_nodes_in_group("area1")
	if area1_nodes.size() > 0:
		print("Applying effects to area1 nodes for card ID:", id)
		apply_effects(area1_nodes)
	
	# Handle area2 nodes
	var area2_nodes = tree.get_nodes_in_group("area2")
	if area2_nodes.size() > 0:
		print("Applying effects to area2 nodes for card ID:", id)
		apply_effects(area2_nodes)

	apply_effects(targets)

	
	print("Play successful for card ID:", id, "Targets:", targets)
	return true


func apply_effects(_targets: Array[Node]):
	pass


# Simulate the effects of the card on an array of targets
func simulate_effects(targets: Array[Node]):
	print("Card: Simulate effects called for card ID:", id)

	if targets.size() > 0:
		var tree := targets[0].get_tree()  # Access the scene tree
		var area1_nodes = tree.get_nodes_in_group("area1")  # Find nodes in "area1" group
		
		if area1_nodes.size() > 0:
			print("Simulating effects on area1 nodes for card ID:", id)
			print("Simulating for targets:", targets)
			print("Targets in area1 group:", area1_nodes)

			simulate_individual_effects(area1_nodes)  # Simulate effects on area1 nodes
			
		# Handle area2 nodes
		var area2_nodes = tree.get_nodes_in_group("area2")  # Find nodes in "area2" group
		if area2_nodes.size() > 0:
			print("Simulating effects on area2 nodes for card ID:", id)
			print("Simulating for targets:", targets)
			print("Targets in area2 group:", area2_nodes)
			simulate_individual_effects(area2_nodes)  # Simulate effects on area2 nodes

	simulate_individual_effects(targets)  # Simulate effects on general targets
	print("Simulation successful for card ID:", id, "Targets:", targets)



# To be overridden for specific card simulation behavior
func simulate_individual_effects(_targets: Array[Node]):
	pass
