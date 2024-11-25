extends Card

var card := Card

func apply_effects(targets: Array[Node]) -> void:
	var quality_effect := QualityEffect.new()
	var popularity_effect := PopularityEffect.new()
	quality_effect.amount = 10
	popularity_effect.amount = 10
	quality_effect.execute(targets)
	popularity_effect.execute(targets)


func simulate_individual_effects(targets: Array[Node]) -> void:
	var quality_effect := QualityEffect.new()
	var popularity_effect := PopularityEffect.new()
	quality_effect.amount = 10
	popularity_effect.amount = 10
	quality_effect.simulate(targets)  # Call simulate instead of execute
	popularity_effect.simulate(targets)  # Call simulate instead of execute
