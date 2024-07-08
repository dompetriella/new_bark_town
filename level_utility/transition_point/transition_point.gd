extends Area2D

@export var next_scene_path: String;

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area.get_parent() is Player && next_scene_path != null):
		Events.transition_to_new_scene.emit(next_scene_path);
