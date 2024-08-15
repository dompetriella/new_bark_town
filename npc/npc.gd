class_name Npc
extends Node2D

@export var spriteFrames: SpriteFrames;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite: AnimatedSprite2D = %NpcSprite;
	if (spriteFrames != null):
		sprite.sprite_frames = spriteFrames;
		
func change_npc_direction_to_match_player(player_facing_raycast: RayCast2D):
	var raycast_vector: Vector2 = player_facing_raycast.target_position;
	var player_facing_direction = Vector2.DOWN;
	var npc_facing_direction = Vector2.DOWN;
	var sprite: AnimatedSprite2D = %NpcSprite;
	
	# player is facing right, npc face left
	if (raycast_vector.x > 0):
		npc_facing_direction = Vector2.LEFT;
	# player is facing left, npc face right
	if (raycast_vector.x < 0):
		npc_facing_direction = Vector2.RIGHT;
	# player is facing up, npc face down
	if (raycast_vector.y < 0):
		npc_facing_direction = Vector2.DOWN;
	#player is facing down, npc face up
	if (raycast_vector.y > 0):
		npc_facing_direction = Vector2.UP;
	
	match npc_facing_direction:
		Vector2.UP:
			sprite.play("look_up");
		Vector2.DOWN:
			sprite.play("look_down");
		Vector2.RIGHT:
			sprite.play("look_right");
		Vector2.LEFT:
			sprite.play("look_left");
		
