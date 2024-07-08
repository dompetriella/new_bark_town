extends Area2D

@export var next_scene: PackedScene;

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area.get_parent() is Player && next_scene != null):
		Events.transition_to_new_scene.emit(next_scene);
