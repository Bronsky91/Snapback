extends NinePatchRect

export(String, FILE, "*.json") var dialogue_file

var dialogues = []

func _ready():
	pass
	
func play():
	show()
	dialogues = load_dialogue()
	$Name.bbcode_text = dialogues[0]['name']
	$Message.bbcode_text = dialogues[0]['text']
	
func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())
