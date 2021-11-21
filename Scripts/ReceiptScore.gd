extends NinePatchRect


func _ready():
	$Coins.text = str(g.final_score.coins)
	$Slices.text = str(g.final_score.slices_lost)
	$Time.text = g.final_score.timestamp
	$Skelebois.text = str(g.final_score.skellies_talked_to) + " pts"
	$Inverted.text = str(g.final_score.inversions) + " times"
	var score_num = g.final_score.time
	score_num += g.final_score.coins * 5
	score_num += g.final_score.skellies_talked_to * 20
	score_num += g.final_score.slices_lost * -20
	$Score.text = str(score_num)
