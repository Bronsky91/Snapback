extends NinePatchRect

export(String, FILE, "*.json") var skele_dialogue_file
export(String, FILE, "*.json") var in_danger_skele_dialogue_file
export (String, FILE, "*.json") var painter_dialogue_file

var dialogues = []
var in_danger_dialogues = []
var painter_dialogues = []

func _ready():
	dialogues = load_dialogue(skele_dialogue_file)
	in_danger_dialogues = load_dialogue(in_danger_skele_dialogue_file)
	painter_dialogues = load_dialogue(painter_dialogue_file)

func skele_play(status, skelly_name, skelly_text = ""):
	randomize()
	
	var dialogues_array = []
	if status == 'painter':
		dialogues_array = painter_dialogues
	if status == 'in danger':
		dialogues_array = concat_arrays(dialogues, in_danger_dialogues)
	else:
		dialogues_array = dialogues
		
	var dialogue_count = dialogues_array.size()
	var random_dialogue = dialogues_array[randi() % dialogue_count]
	print(random_dialogue)
	$Name.bbcode_text = skelly_name
	$Message.bbcode_text = skelly_text if skelly_text else random_dialogue
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
