class_name TransitionPoint
extends Area2D

enum MovementDirection { DOWN, RIGHT, UP, LEFT}

@export var next_scene_path: String;
@export var end_point_coordinates: Vector2;
@export var direction_after_transition: MovementDirection;
@export var music_track_path: String;

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area.get_parent() is Player && next_scene_path != null):
		if (!Globals.is_transitioning_between_scenes):
			var level_container: LevelContainer = get_tree().get_first_node_in_group("LevelContainer");
			Globals.is_transitioning_between_scenes = true;
			Events.play_fade_transition.emit();
			await get_tree().create_timer(0.25).timeout;
			if (next_scene_path == null):
				print("given scene is null, nothing will happen");
				return;
			var next_scene_packed = load(next_scene_path);
			var next_level_instance: Node2D = next_scene_packed.instantiate();
			var current_level: Node2D = level_container.get_child(0);
			if (current_level != null):
				await get_tree().process_frame;
				level_container.add_child(next_level_instance);
				current_level.visible = false;
				await move_player_after_transition(end_point_coordinates, direction_after_transition);
				current_level.queue_free();
			if (music_track_path != ''):
				Events.play_background_music.emit(music_track_path);
			
func move_player_after_transition(new_coordinates: Vector2, direction_after_transition: MovementDirection):
	var player: Player = get_tree().get_first_node_in_group("Player");
	var player_sprite: AnimatedSprite2D = player.get_node("%PlayerSprite");
	player.is_autonomous = false;
	player.global_position = new_coordinates;
	player.is_moving = false;
	var vector_direction: Vector2 = Vector2.ZERO;
	if (direction_after_transition == MovementDirection.UP):
		vector_direction = Vector2.UP;
	if (direction_after_transition == MovementDirection.DOWN):
		vector_direction = Vector2.DOWN;
	
	print("Moving in direction: " + str(vector_direction));
	await player.move_character(vector_direction, player_sprite, true, end_point_coordinates);
	
	await get_tree().create_timer(0.5).timeout;
	player.is_moving = false
	player.is_autonomous = true
	Globals.is_transitioning_between_scenes = false
	
	
