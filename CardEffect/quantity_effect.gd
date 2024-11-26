class_name QuantityEffect
extends Effect

var amount := 0

# set the card number to 5 in their resources, then multiple by 2 here according to target
func execute(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.quantity_changed(amount * 2)
		elif target is Area2:
			target.quantity_changed(amount)
		elif target is Area3:
			target.quantity_changed(amount)
		elif target is Area4:
			target.quantity_changed(amount * 0.5)
		elif target is Area5:
			target.quantity_changed(amount)


func simulate(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.simulate_quantity(amount * 2)  # UI-only simulation
		elif target is Area2:
			target.simulate_quantity(amount)
		elif target is Area3:
			target.simulate_quantity(amount)
		elif target is Area4:
			target.simulate_quantity(amount * 0.5)
		elif target is Area5:
			target.simulate_quantity(amount)
