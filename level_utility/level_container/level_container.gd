extends Node
class_name LevelContainer

var is_transitioning: bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.transition_to_new_scene.connect(_transition_level);

func _transition_level(new_scene_path: String):
	if (!is_transitioning):
		is_transitioning = true;
		if (new_scene_path == null):
			print("given scene is null, nothing will happen");
			return;

		var new_scene_packed = load(new_scene_path);
		var new_level_instance: Node2D = new_scene_packed.instantiate();
		var new_level_children: Array[Node] = new_level_instance.get_children();
		
		var new_coordinates: Vector2;
		for node in new_level_children:
			if (node is Marker2D):
				new_coordinates = node.global_position;
		var current_level: Node2D = self.get_child(0);
		if (current_level != null):
			await get_tree().process_frame;
			self.add_child(new_level_instance);
			current_level.queue_free();
			move_player_after_transition(new_coordinates, Vector2.DOWN);
		
func move_player_after_transition(new_coordinates: Vector2, direction: Vector2):
	var player: Player = get_tree().get_first_node_in_group("Player");
	var player_sprite: AnimatedSprite2D = player.get_node("%PlayerSprite");
	player.is_autonomous = false;
	player.global_position = new_coordinates;
	player.move_character(direction, player_sprite);
	await get_tree().create_timer(1.0).timeout;
	player.is_autonomous = true;
	is_transitioning = false;
	
	
	
