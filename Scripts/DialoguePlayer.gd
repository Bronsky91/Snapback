extends NinePatchRect

export(String, FILE, "*.json") var dialogue_file

var dialogues = []
var dialogue_count

func _ready():
	dialogues = load_skele_dialogue()
	dialogue_count = dialogues.size()
	
func skele_play(text):
	randomize()
	var random_dialogue = dialogues[randi() % dialogue_count]
	$Name.bbcode_text = random_dialogue['name']
	$Message.bbcode_text = text if text else random_dialogue['text']
	show()
	
func load_skele_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
