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
	Events.card_played.emit(self)
	
	# Check if there is enough funding
	if player_stats.funding + funding < 0:
		return false
	
	player_stats.funding += funding
	
	
	var tree := targets[0].get_tree()
	var area1_nodes = tree.get_nodes_in_group("area1")
	if area1_nodes.size() > 0:
		apply_effects(area1_nodes)
	
	apply_effects(targets)
	print("Targets:", targets)
	print("Player funding before:", player_stats.funding)
	
	return true



func apply_effects(_targets: Array[Node]):
	pass
