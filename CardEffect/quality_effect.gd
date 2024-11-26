class_name QualityEffect
extends Effect

var amount := 0

# set the card number to 5 in their resources, then multiple by 2 here according to target
func execute(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.quality_changed(amount)
		elif target is Area2:
			target.quality_changed(amount * 2)
		elif target is Area3:
			target.quality_changed(amount * 2)
		elif target is Area4:
			target.quality_changed(amount)
		elif target is Area5:
			target.quality_changed(amount)


func simulate(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.simulate_quality(amount)  # UI-only simulation
		elif target is Area2:
			target.simulate_quality(amount * 2)
		elif target is Area3:
			target.simulate_quality(amount * 2)
		elif target is Area4:
			target.simulate_quality(amount)
		elif target is Area5:
			target.simulate_quality(amount)
