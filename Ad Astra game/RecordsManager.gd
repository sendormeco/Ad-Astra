extends Node

# Всегда содержит ровно 5 элементов, сортированных по убыванию
var top_scores: Array = [0, 0, 0, 0, 0]

func _ready():
	load_records()

func save_records():
	var file = FileAccess.open("user://top_scores.dat", FileAccess.WRITE)
	if file:
		file.store_var(top_scores)
	else:
		push_error("Ошибка сохранения рекордов!")

func load_records():
	if FileAccess.file_exists("user://top_scores.dat"):
		var file = FileAccess.open("user://top_scores.dat", FileAccess.READ)
		if file:
			var loaded = file.get_var()
			if loaded is Array and loaded.size() == 5:
				top_scores = loaded
				top_scores.sort_custom(func(a, b): return a > b)
			else:
				reset_records()
	else:
		reset_records()

func reset_records():
	top_scores = [0, 0, 0, 0, 0]
	save_records()

func is_new_record(score: int) -> bool:
	return score > top_scores[4]  # Сравниваем с последним (5-м) элементом

func add_record(score: int):
	if not is_new_record(score):
		return
	
	# Заменяем минимальный рекорд
	top_scores[4] = score
	
	# Сортируем по убыванию
	top_scores.sort_custom(func(a, b): return a > b)
	
	save_records()
	print("Добавлен новый рекорд. Текущие рекорды:", top_scores)
