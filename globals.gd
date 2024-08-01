extends Node

enum MovementDirection { DOWN, RIGHT, UP, LEFT}

var is_transitioning_between_scenes: bool = false;

var interactive_area_component: InteractiveAreaComponent = null;
