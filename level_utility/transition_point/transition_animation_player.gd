extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.play_fade_transition.connect(
		func():
			self.play("area_transition");
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
