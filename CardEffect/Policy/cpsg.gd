extends Card

var card := Card

func apply_effects(targets: Array[Node]) -> void:
	var popularity_effect := PopularityEffect.new()
	popularity_effect.amount = 5
	popularity_effect.execute(targets)


func simulate_individual_effects(targets: Array[Node]) -> void:
	var popularity_effect := PopularityEffect.new()
	popularity_effect.amount = 5
	popularity_effect.simulate(targets)  # Call simulate instead of execute
