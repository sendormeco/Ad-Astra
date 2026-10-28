extends Button

const HIGH_SCORE_FILE = "user://high_score.cfg"
@onready var high_score = 0

func _ready():
	pressed.connect(_on_share_pressed)
	var config = ConfigFile.new()
	if config.load(HIGH_SCORE_FILE) == OK:
		high_score = config.get_value("HighScore", "score", 0)

func _on_share_pressed():
	var share_text = "Я набрал %d очков в Ad Astra! 🎮\nПопробуй побить мой рекорд!" % high_score
	var store_url = "https://www.rustore.ru/catalog/app/com.example.adastra"
	
	if OS.has_feature("android"):
		_share_android(share_text + "\n" + store_url)
	elif OS.has_feature("windows") or OS.has_feature("macos") or OS.has_feature("linux"):
		_share_desktop(share_text, store_url)
	else:  # iOS и другие платформы
		_share_fallback(share_text + "\n" + store_url)

# Android-реализация через Intent (без плагина)
func _share_android(text: String):
	var args = [
		"start",
		"-a", "android.intent.action.SEND",
		"-t", "text/plain",
		"--es", "android.intent.extra.TEXT", text
	]
	# Третий параметр должен быть массивом (output = []), а не false
	var output = []
	var exit_code = OS.execute("am", args, output)
	
	if exit_code != 0:
		# Fallback: копирование в буфер, если Intent не сработал
		DisplayServer.clipboard_set(text)
		OS.alert("Скопировано в буфер: " + text, "Поделиться")

# Для ПК (открытие Twitter/браузера)
func _share_desktop(text: String, url: String):
	var twitter_url = "https://twitter.com/intent/tweet?text=%s&url=%s" % [text.uri_encode(), url.uri_encode()]
	OS.shell_open(twitter_url)  # Или просто копирование в буфер:
	DisplayServer.clipboard_set(text + "\n" + url)
	OS.alert("Текст скопирован в буфер!", "Поделиться")

# Универсальный fallback
func _share_fallback(text: String):
	DisplayServer.clipboard_set(text)
	OS.alert("Скопировано в буфер: " + text, "Поделиться")
