class_name QuantityEffect
extends Effect

var amount := 0

# set the card number to 5 in their resources, then multiple by 2 here according to target
func execute(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.quantity_changed(amount)

func simulate(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.simulate_quantity(amount)  # UI-only simulation
