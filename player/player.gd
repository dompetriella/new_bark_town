extends Node2D
class_name Player

@export var speed: int = 50;

@onready var raycast_north: RayCast2D = get_node("%RaycastNorth");
@onready var raycast_south: RayCast2D = get_node("%RaycastSouth");
@onready var raycast_east: RayCast2D = get_node("%RaycastEast");
@onready var raycast_west: RayCast2D = get_node("%RaycastWest");
@onready var player_sprite: AnimatedSprite2D = get_node("%PlayerSprite");

const tile_size: int = 16;
var is_moving: bool = false;
var input_direction: Vector2;

func _ready() -> void:
	pass;

func _physics_process(delta: float) -> void:
	input_direction = Vector2.ZERO;
	
	## Facing
	if (Input.is_action_just_pressed("ui_up")):
		input_direction = Vector2.UP;
		player_sprite.play("face_up");
		
	elif (Input.is_action_just_pressed("ui_down")):
		input_direction = Vector2.DOWN;
		player_sprite.play("face_down");
		
	elif (Input.is_action_just_pressed("ui_right")):
		input_direction = Vector2.RIGHT;
		player_sprite.play("face_right");
		
	elif (Input.is_action_just_pressed("ui_left")):
		input_direction = Vector2.LEFT;
		player_sprite.play("face_left");
	
	## Movement
	elif ( Input.is_action_pressed("ui_up")):
		input_direction = Vector2.UP;
		player_sprite.play("walk_up");
		move_character();
	elif ( Input.is_action_pressed("ui_down")):
		input_direction = Vector2.DOWN;
		player_sprite.play("walk_down");
		move_character();
	elif (Input.is_action_pressed("ui_right")):
		input_direction = Vector2.RIGHT
		player_sprite.play("walk_right");
		move_character();
	elif (Input.is_action_pressed("ui_left")):
		input_direction = Vector2.LEFT;
		player_sprite.play("walk_left");
		move_character();
		



func move_character() -> void:
	if (input_direction): 
		if (!is_moving && !will_collide_with_physics_object()):
			is_moving = true;
			var movement_tween: Tween = create_tween();
			movement_tween.tween_property(self, "position", position + input_direction * tile_size, (0.2));
			movement_tween.tween_callback(func(): is_moving = false);
			
func will_collide_with_physics_object() -> bool:
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
