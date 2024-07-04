extends CharacterBody2D

@onready var collision_raycast: RayCast2D = get_node("%CollisionRaycast");

const tile_size: int = 8;
var is_moving: bool = false;
var input_direction: Vector2;

func _ready() -> void:
	collision_raycast.collision_mask = 2;


func _physics_process(delta: float) -> void:
	if collision_raycast.is_colliding():
		var x = collision_raycast.get_collider();
		print(x);
	input_direction = Vector2.ZERO;
	if Input.is_action_just_pressed("ui_up"):
		input_direction = Vector2.UP;
		move_character();
	elif Input.is_action_just_pressed("ui_down"):
		input_direction = Vector2.DOWN;
		move_character();
	elif Input.is_action_just_pressed("ui_right"):
		input_direction = Vector2.RIGHT
		move_character();
	elif Input.is_action_just_pressed("ui_left"):
		input_direction = Vector2.LEFT;
		move_character();

func move_character() -> void:
	if input_direction: 
		if !is_moving:
			is_moving = true;
			var movement_tween: Tween = create_tween();
			movement_tween.tween_property(self, "position", position + input_direction * tile_size, 0.1);
			movement_tween.tween_callback(func(): is_moving = false);
