extends Node2D
class_name Player

@onready var raycast_north: RayCast2D = get_node("%CollisionRaycastNorth");
@onready var raycast_south: RayCast2D = get_node("%CollisionRaycastSouth");
@onready var raycast_east: RayCast2D = get_node("%CollisionRaycastEast");
@onready var raycast_west: RayCast2D = get_node("%CollisionRaycastWest");
@onready var interactive_raycast_north: RayCast2D = get_node("%InteractiveRaycastNorth");
@onready var interactive_raycast_south: RayCast2D = get_node("%InteractiveRaycastSouth");
@onready var interactive_raycast_east: RayCast2D = get_node("%InteractiveRaycastEast");
@onready var interactive_raycast_west: RayCast2D = get_node("%InteractiveRaycastWest");
@onready var player_sprite: AnimatedSprite2D = get_node("%PlayerSprite");
@onready var collision_noise_timer: Timer = get_node("%CollisionNoiseTimer");

const tile_size: int = 16;
var is_moving: bool = false;
var movement_animation_uses_right_arm: bool = true;
var is_autonomous: bool = true;
var is_in_menu: bool = false;
var input_direction: Vector2;
var player_facing_raycast: RayCast2D;
var can_emit_collide_noise: bool = true;

func _ready() -> void:
	Events.change_player_position.connect(change_player_position);
	DialogueManager.dialogue_ended.connect(func(resource): 
		await get_tree().create_timer(0.2).timeout;
		is_in_menu = false
		);
	player_facing_raycast = interactive_raycast_south;

func change_player_position(new_position: Vector2):
	self.global_position = new_position;
	print(new_position);

func _physics_process(delta: float) -> void:
	input_direction = Vector2.ZERO;
	if (is_autonomous && !is_in_menu):
	## Facing
		#if (Input.is_action_just_pressed("ui_up")):
			#input_direction = Vector2.UP;
			#player_sprite.play("face_up");
			#
		#elif (Input.is_action_just_pressed("ui_down")):
			#input_direction = Vector2.DOWN;
			#player_sprite.play("face_down");
			#
		#elif (Input.is_action_just_pressed("ui_right")):
			#input_direction = Vector2.RIGHT;
			#player_sprite.play("face_right");
			#
		#elif (Input.is_action_just_pressed("ui_left")):
			#input_direction = Vector2.LEFT;
			#player_sprite.play("face_left");
		
		## Movement
		if ( Input.is_action_pressed("ui_up")):
			move_character(Vector2.UP, player_sprite);
			player_facing_raycast = interactive_raycast_north;
		elif ( Input.is_action_pressed("ui_down")):
			move_character(Vector2.DOWN, player_sprite);
			player_facing_raycast = interactive_raycast_south;
		elif (Input.is_action_pressed("ui_right")):
			move_character(Vector2.RIGHT, player_sprite);
			player_facing_raycast = interactive_raycast_east;
		elif (Input.is_action_pressed("ui_left")):
			move_character(Vector2.LEFT, player_sprite);
			player_facing_raycast = interactive_raycast_west;
			
	if (Input.is_action_just_pressed("ui_select") && !is_moving && player_facing_raycast.is_colliding()):
		var collider:  Node2D = player_facing_raycast.get_collider();
		if (collider is InteractiveAreaComponent):
			if (collider.dialogue_resource != null && !is_in_menu):
				Events.play_sfx.emit("res://assets/sound/sfx/select_sfx.mp3");
				is_in_menu = true;
				if (collider.get_parent() is Npc):
					var npc: Npc = collider.get_parent();
					npc.change_npc_direction_to_match_player(player_facing_raycast);
				DialogueManager.show_dialogue_balloon(collider.dialogue_resource, "start");
				

				

func move_character(input_direction: Vector2, player_sprite: AnimatedSprite2D, uses_external_position: bool = false, external_position: Vector2 = Vector2.ZERO) -> void:

	match (input_direction):
		Vector2.RIGHT:
			player_sprite.play("walk_right"); 
		Vector2.LEFT:
			player_sprite.play("walk_left");
		Vector2.UP:
			if (movement_animation_uses_right_arm):
				player_sprite.play("walk_up_right_arm");
			else:
				player_sprite.play("walk_up_left_arm");
		Vector2.DOWN:
			if (movement_animation_uses_right_arm):
				player_sprite.play("walk_down_right_arm");
			else:
				player_sprite.play("walk_down_left_arm");
		_:
				pass;
			
			
	if ((!is_moving && !will_collide_with_physics_object(input_direction)) || uses_external_position):
		is_moving = true;
		var current_position: Vector2;
		if (uses_external_position):
			current_position = external_position;
		else:
			current_position = self.global_position;
		var next_position = current_position + input_direction * tile_size;
		var movement_tween: Tween = create_tween();
		print("given external position: " + str(external_position));
		print("current position: " + str(current_position) );
		print("moving to: " + str(next_position) + "\n");
		movement_tween.tween_property(self, "global_position", next_position, (0.22)).from_current();
		movement_tween.tween_callback(func(): 
			is_moving = false
			movement_animation_uses_right_arm = !movement_animation_uses_right_arm;
		);
	elif (will_collide_with_physics_object(input_direction) && player_facing_raycast.get_collider() is not TransitionPoint):
		if (self.can_emit_collide_noise):
			Events.play_sfx.emit("res://assets/sound/sfx/player_collision.mp3");
			self.can_emit_collide_noise = false;
			collision_noise_timer.start();
			

	
			
func will_collide_with_physics_object(input_direction: Vector2) -> bool:
	var will_collide = false;
	if (input_direction == Vector2.UP && raycast_north.is_colliding()):
		will_collide = true;
	if (input_direction == Vector2.DOWN && raycast_south.is_colliding()):
		will_collide = true;
	if (input_direction == Vector2.RIGHT && raycast_east.is_colliding()):
		will_collide = true;
	if (input_direction == Vector2.LEFT && raycast_west.is_colliding()):
		will_collide = true;
	return will_collide;


func _on_collision_noise_timer_timeout() -> void:
	can_emit_collide_noise = true;
