class_name Help

var notices: Array[String] = []

func reset():
	notices = []

func issue_notice(name: String):
	if notices.has(name):
		return
	
	match name:
		"Glass":
			notices.push_back(name)
			Global.player.show_speech_bubble("This glass looks\n sharp. I better\n tread lightly.", 2.5)
		"SideBuildingFireEscape":
			notices.push_back(name)
			Global.player.show_speech_bubble("It's broken...\nI'll have to find\na different way out.", 2.5)
