extends NinePatchRect


func _ready():
	$Coins.bbcode_text = right(g.final_score.coins)
	$Slices.bbcode_text = right(g.final_score.slices_lost)
	$Time.bbcode_text = right(g.final_score.timestamp)
	$Skelebois.bbcode_text = right(g.final_score.skellies_talked_to)
	$Inverted.bbcode_text = right(g.final_score.inversions)


# Called when the node enters the scene tree for the first time.
func set_score(coins, slices, time, skelebois, inverted):
	pass


func right(content):
	return "[right]" + str(content) + "[/right]"
