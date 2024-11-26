extends Node


signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested


signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended

signal simulation_started(card: Card, target: Node)
signal simulation_ended()
signal simulation_started_2(card: Card, target: Node)
signal simulation_ended_2()
signal simulation_started_3(card: Card, target: Node)
signal simulation_ended_3()
signal simulation_started_4(card: Card, target: Node)
signal simulation_ended_4()
signal simulation_started_5(card: Card, target: Node)
signal simulation_ended_5()
