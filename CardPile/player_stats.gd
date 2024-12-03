class_name PlayerStats
extends Resource

signal player_stats_changed


@export var innitial_funding: int


@export var max_policy_card: int
@export var max_tech_card: int


@export var policy_card_deck: CardPile
@export var policy_card_draw_pile: CardPile
@export var policy_card_discard : CardPile

@export var tech_card_deck: CardPile
@export var tech_card_draw_pile: CardPile
@export var tech_card_discard: CardPile


var funding: int : set = set_funding

# Function to initialize and shuffle the draw piles
func initialize_card_piles():
	policy_card_draw_pile.shuffle()
	tech_card_draw_pile.shuffle()
	
	print("Shuffled Policy Deck:", policy_card_draw_pile.cards)
	print("Shuffled Tech Deck:", tech_card_draw_pile.cards)

	print("PlayerStats: Card piles initialized and shuffled.")


func set_funding(value: int):
	funding = value
	#print("Emitting player_stats_changed signal with funding:", funding)
	player_stats_changed.emit(self)

func funding_changed(amount: int):
	set_funding(self.funding + amount)



func can_play_policy_card(card: Card)-> bool:
	return funding + card.funding > 0 

func can_play_tech_card(card: Card)-> bool:
	return funding + card.funding > 0 



func create_instance() -> Resource:
	var instance: PlayerStats = self.duplicate()
	instance.funding = innitial_funding
	instance.initialize_card_piles()  # Initialize the card piles when creating the instance
	return instance
