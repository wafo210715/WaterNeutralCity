extends Card

var card := Card

func apply_effects(targets: Array[Node]) -> void:
	var popularity_effect := PopularityEffect.new()
	popularity_effect.amount = -10
	popularity_effect.execute(targets)
	
	var quality_effect := QualityEffect.new()
	quality_effect.amount = -10
	quality_effect.execute(targets)
	
	# var quantity_effect := QuantityEffect.new()
	# quantity_effect.amount = -10
	# quantity_effect.execute(targets)
