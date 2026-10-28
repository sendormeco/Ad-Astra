extends Node

signal ad_finished

var test_mode: bool = OS.is_debug_build()
var ad_show_count: int = 0

func show_ad():
	if test_mode:
		# В редакторе просто делаем задержку
		print("Showing TEST ad (3 sec)")
		await get_tree().create_timer(3.0).timeout
	else:
		# На реальном устройстве
		if Engine.has_singleton("AdMob"):
			var admob = Engine.get_singleton("AdMob")
			admob.show_interstitial()
			await get_tree().create_timer(1.0).timeout  # Задержка для инициализации
			return
	
	# Всегда эмитируем сигнал завершения
	ad_finished.emit()
