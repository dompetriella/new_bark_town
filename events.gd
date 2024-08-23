extends Node

signal transition_to_new_scene(new_scene_path: String);
signal play_fade_transition;
signal change_player_position(new_position: Vector2);

#audio
signal play_background_music(audio_path: String);
signal play_sfx(audio_path: String);
