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


func issue_is_water_quality() -> bool:
	return target_issue == TargetIssue.WATER_QUALITY


func issue_is_water_quantity() -> bool:
	return target_issue == TargetIssue.WATER_QUANTITY
