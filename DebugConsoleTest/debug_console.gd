extends Control

@export var input : LineEdit
@export var output : TextEdit
@export var input_suggestions : Control
@export var commands : Node

var available_commands = []
var matches = []

func _ready():
	input.connect("text_changed", on_search)
	input.connect("text_submitted", on_command)
	input.grab_focus()
	
	# THIS ENTIRE BLOCK IS DEDICATED ONLY TO VISUALS LOL
	var label_settings = LabelSettings.new()
	label_settings.shadow_size = 0
	label_settings.shadow_color = Color(0, 0, 0, 0.80392158031464)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 1)
	style.corner_detail = 5
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.content_margin_left = 5
	style.content_margin_right = 5
	
	for i in commands.valid_commands:
		var label = Label.new()
		label.label_settings = label_settings
		label.set("theme_override_styles/normal", style)
		label.text = str(i[0])
		label.hide()
		input_suggestions.call_deferred("add_child", label)


func _input(event):
	if (Input.is_action_just_pressed("tab") or Input.is_action_just_pressed("enter")) and matches.size() > 0:
		input.text = str(matches[-1].text)
		input.set_caret_column(len(matches[-1].text))

func output_text(text : String):
	output.text = str(output.text, "\n", text)
	output.set_v_scroll(99999999)

# AFTER RECEIVING THE COMMAND FROM THE LINE EDIT INPUT, THIS WILL MAKE SURE THE COMMAND AND
# PARAMETERS (IF ANY) YOU WROTE ARE VALID AND THEN CALL THE HOMONYMOUS FUNCTION, SO IT'S
# VERY IMPORTANT TO WRITE IT CORRECTLY IN THE LINE EDIT AND THE COMMANDS SCRIPT
func process_command(command : String):
	var words = command.split(" ")
	words = Array(words)
	
	for i in range(words.count("")):
		words.erase("")
	
	if words.size() == 0:
		return
	
	var command_word = words.pop_front()
	
	for c in commands.valid_commands:
		if c[0] == command_word:
			if c.size() == 1:
				output_text(commands.call(command_word))
				return
			if words.size() != c[1].size():
				output_text(str('Failure executing command "', command_word, '", expected ', c[1].size(), ' parameters'))
				return
			for i in range(words.size()):
				if not check_type(words[i], c[1][i]):
					output_text(str('Failure executing command "', command_word, '", parameter ', (i + 1),
								' ("', words[i], '") is of the wrong type'))
					return
			output_text(commands.callv(command_word, convert_to_parameters(words)))
			return
	output_text(str('Command "', command_word, '" does not exist.'))

func convert_to_parameters(words : Array):
	var parameters = []
	for string in words:
		if string.is_valid_int() and not "." in string:
			string = int(string)
		elif string.is_valid_float() and "." in string:
			string = float(string)
		elif string == "true":
			string = true
		elif string == "false":
			string = false
		else:
			string = String(string)
		parameters.append(string)
	return parameters

func check_type(string, type):
	if type == commands.INT:
		return string.is_valid_int()
	if type == commands.FLOAT:
		return string.is_valid_float()
	if type == commands.BOOL:
		return (string == "true" or string == "false")
	if type == commands.STRING:
		return true
	return false

func on_command(command : String):
	input.clear()
	process_command(command)

func on_search(search : String):
	if search == "":
		matches.clear()
	var suggestions = input_suggestions.get_children()
	matches.clear()
	for i in suggestions:
		if search.to_lower() in i.text.to_lower():
			matches.append(i)
	for i in suggestions:
		i.show() if i in matches else i.hide()
	if matches.size() > 0:
		var yellow_tint = LabelSettings.new()
		yellow_tint = matches[0].label_settings
		yellow_tint.font_color = Color(1, 0.90980392694473, 0.40000000596046)
		matches[0].label_settings = yellow_tint
