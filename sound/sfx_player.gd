extends AudioStreamPlayer2D


func _ready() -> void:
	Events.play_sfx.connect(_on_play_background_music);

func _on_play_background_music(sfx_path: String):
	var sfx: Resource = load(sfx_path);
	self.stream = sfx;
	self.play();
