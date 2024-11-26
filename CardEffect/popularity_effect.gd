class_name PopularityEffect
extends Effect

var amount := 0

# set the card number to 5 in their resources, then multiple by 2 here according to target
func execute(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.popularity_changed(amount)
		elif target is Area2:
			target.popularity_changed(amount * 2)
		elif target is Area3:
			target.popularity_changed(amount * 2)
		elif target is Area4:
			target.popularity_changed(amount * 2)
		elif target is Area5:
			target.popularity_changed(amount)



func simulate(targets: Array[Node]):
	for target in targets:
		if not target:
			continue
		if target is Area1:
			target.simulate_popularity(amount)  # UI-only simulation
		elif target is Area2:
			target.simulate_popularity(amount * 2)
		elif target is Area3:
			target.simulate_popularity(amount * 2)
		elif target is Area4:
			target.simulate_popularity(amount * 2)
		elif target is Area5:
			target.simulate_popularity(amount)
