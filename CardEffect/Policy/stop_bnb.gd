extends Card

var card := Card

func apply_effects(targets: Array[Node]) -> void:
	var quantity_effect := QuantityEffect.new()
	quantity_effect.amount = 15
	quantity_effect.execute(targets)


func simulate_individual_effects(targets: Array[Node]) -> void:
	var quantity_effect := QuantityEffect.new()
	quantity_effect.amount = 15
	quantity_effect.simulate(targets)  # Call simulate instead of execute
