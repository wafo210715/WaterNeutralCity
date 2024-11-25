class_name PlayerStatsUI
extends HBoxContainer


@onready var funding_image: TextureRect = %FundingImage
@onready var funding_text: Label = %FundingText

var tween: Tween


func update_stats(stats: PlayerStats):
	# set the pivot in the center of the image, so the animation looks more centered
	funding_image.pivot_offset = Vector2(39, 39)
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(funding_image, "scale", Vector2(1.2, 1.2), 0.5)
	
	funding_text.text = str(stats.funding)
	
	tween.tween_property(funding_image, "scale", Vector2(1.0, 1.0), 0.5)
