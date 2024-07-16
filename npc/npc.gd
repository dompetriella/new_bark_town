extends Node2D

@export var spriteFrames: SpriteFrames;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite: AnimatedSprite2D = %NpcSprite;
	if (spriteFrames != null):
		sprite.sprite_frames = spriteFrames;
	
