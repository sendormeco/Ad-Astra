extends CanvasLayer

@export var next_scene: PackedScene
@export var min_loading_time: float = 2.0  # Минимальное время показа экрана
@onready var progress_bar = $ProgressBar
@onready var tip_label = $TipLabel


var loading_start_time: float
var is_scene_loaded: bool = false
var tips = [
	"Теперь с шейдерами!",
	"Загрузка текстур...",
	"Патч 1.0: исправлены баги",
	"Оптимизация для вашего устройства...",
	"Инициализация игровых систем",
	"Дефрагментация квантовых частиц",
	"Выравнивание ковариационных матриц",
	"Загрузка дополнительной оперативки.",
	"Полировка полигонов",
	"Подготовка к возрождению...",
	"Прокачка шкалы загрузки",
	"Загрузка — это состояние сознания",
	"Шкала загрузки врет...",
	"Загружаюсь... или нет?",
	"Собираю котиков в кучу. Подождите.",
	"В поисках смысла жизни...",
	"Консультация с Дельфийским оракулом",
	"Разогреваем кофе...",
	"Ждём, пока сюжет загустеет",
	"Добавляем больше блеска ✨",
	"Распутываем провода наушников",
	"Читаем алфавит задом наперед",
	"Ищем клавишу 'Any'",
	"Настройка параметров гравитации",
	"Будим разработчика (аккуратно)",
	# Новые варианты:
	"Переворачивем пингвинов",
	"Затачиваем мечи",
	"Переписываем законы физики",
	"Рисуем пиксели вручную",
	"Перевод на русский...",
	"Собираем пазл вселенной",
	"Разминаем виртуальные мышцы",
	"Считаем до ∞ и обратно",
	"Строим мост в параллельный мир",
	"Учим кота кодить на GDScript",
	"Шепчем ободряющие слова серверу",
	"Импортируем атмосферу",
	"Заказываем пиццу для NPC",
	"Сверяемся с древними свитками",
	"Имитируем бурную деятельность",
	"Придумываем новые достижения"
]

func _ready():
	# Засекаем время начала загрузки
	loading_start_time = Time.get_ticks_msec()
	
	# Случайный совет
	tip_label.text = tips.pick_random()
	
	# Запускаем загрузку
	load_scene_async("res://main_menu.tscn")
	
	# Гарантируем минимальное время показа экрана
	await get_tree().create_timer(min_loading_time).timeout
	try_complete_loading()

func load_scene_async(scene_path: String):
	ResourceLoader.load_threaded_request(scene_path)
	
	# Таймер для проверки прогресса
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.05  # Более частая проверка
	timer.timeout.connect(_update_progress.bind(scene_path))
	timer.start()

func _update_progress(scene_path: String):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		# Плавное заполнение прогресс-бара
		var target_value = progress[0] * 100
		if abs(progress_bar.value - target_value) > 1.0:
			var tween = create_tween()
			tween.tween_property(progress_bar, "value", target_value, 0.2)
	
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		is_scene_loaded = true
		try_complete_loading()

func try_complete_loading():
	# Проверяем прошло ли минимальное время
	var elapsed_time = (Time.get_ticks_msec() - loading_start_time) / 1000.0
	if elapsed_time >= min_loading_time && is_scene_loaded:
		complete_loading()

func complete_loading():
	# Анимация завершения
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 100, 0.3)
	tween.tween_callback(_on_loading_complete)

func _on_loading_complete():
	# Переход к следующей сцене
	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		push_error("Next scene not assigned!")
