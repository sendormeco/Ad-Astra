extends CanvasLayer

func _ready():
	$BackButton.connect("pressed", Callable(self, "_on_back_button_pressed"))
	load_and_display_records()

func load_and_display_records():
	# Загружаем актуальные рекорды
	RecordsManager.load_records()
	
	# Получаем ссылки на все Label
	var record_labels = [
		$VBoxContainer/Label1,
		$VBoxContainer/Label2,
		$VBoxContainer/Label3,
		$VBoxContainer/Label4,
		$VBoxContainer/Label5
	]
	
	# Заполняем каждый Label данными
	for i in range(5):
		# Инициализируем 5 значений по умолчанию (0), если их нет
		var score = 0
		if i < RecordsManager.top_scores.size():
			score = RecordsManager.top_scores[i]
		
		record_labels[i].text = "#%d: %d Pts" % [i + 1, score]

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
