extends Card

var card := Card

func apply_effects(targets: Array[Node]) -> void:
	var quality_effect := QualityEffect.new()
	quality_effect.amount = -20
	quality_effect.execute(targets)
	
	var quantity_effect := QuantityEffect.new()
	quantity_effect.amount = -20
	quantity_effect.execute(targets)
