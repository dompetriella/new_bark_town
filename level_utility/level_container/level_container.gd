extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.transition_to_new_scene.connect(_transition_level);

func _transition_level(new_scene: PackedScene):
	if (new_scene == null):
		print("given scene is null, nothing will happen");
	var new_level_instance: Node2D = new_scene.instantiate();
	var new_level_children: Array[Node] = new_level_instance.get_children();
	var player: Node2D = get_tree().get_first_node_in_group("Player");
	var new_coordinates: Vector2;
	for node in new_level_children:
		if (node is Marker2D):
			new_coordinates = node.global_position;
	var current_level: Node2D = self.get_child(0);
	if (current_level != null):
		current_level.queue_free();
		player.global_position = new_coordinates;
		self.add_child(new_level_instance);
