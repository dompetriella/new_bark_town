extends AudioStreamPlayer2D

func play_background_music_file(fileName: String) -> void:
	if (fileName != ''):
		var background_music: String = 'res://assets/sound/background_music/' + fileName;
		self.play();
