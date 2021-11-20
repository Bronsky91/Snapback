extends NinePatchRect

export(String, FILE, "*.json") var skele_dialogue_file
export(String, FILE, "*.json") var in_danger_skele_dialogue_file

var dialogues = []
var in_danger_dialogues = []

func _ready():
	dialogues = load_dialogue(skele_dialogue_file)
	in_danger_dialogues = load_dialogue(in_danger_skele_dialogue_file)


func skele_play(status, skelly_name, skelly_text = ""):
	randomize()
	var dialogues_array = concat_arrays(dialogues, in_danger_dialogues) if status == 'in danger' else dialogues
	var dialogue_count = dialogues_array.size()
	var random_dialogue = dialogues_array[randi() % dialogue_count]
	$Name.bbcode_text = skelly_name
	$Message.bbcode_text = skelly_text if skelly_text else random_dialogue['text']
	show()


func load_dialogue(dialogue_file):
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())


func lich():
	$Name.bbcode_text = "???"
	$Message.bbcode_text = "You arrive at last..."
	self.visible = true


func concat_arrays(arr1, arr2):
	arr1 += arr2
	return arr1
