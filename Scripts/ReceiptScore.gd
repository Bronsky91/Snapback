extends NinePatchRect


func _ready():
	$Coins.text = str(g.final_score.coins)
	$Slices.text = str(g.final_score.slices_lost)
	$Time.text = g.final_score.timestamp
	$Skelebois.text = str(g.final_score.skellies_talked_to) + " pts"
	$Inverted.text = str(g.final_score.inversions) + " times"
