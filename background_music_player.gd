extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.play_background_music.connect(_on_play_background_music);

func _on_play_background_music(music_path: String):
	
	var music: Resource = load(music_path);
	if (self.stream.resource_path != music_path):
		
		if (self.playing):
			var fade_out_tween: Tween = create_tween();
			fade_out_tween.tween_property(self, "volume_db", -80, (0.5));
			fade_out_tween.tween_callback(
				func():
					self.volume_db = 0;
					self.stream = music;
					self.play();
			);
		else:
			self.stream = music;
			self.play();
