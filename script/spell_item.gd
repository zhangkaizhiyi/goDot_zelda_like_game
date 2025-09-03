class_name SpellItem
extends Resource

@export var texture:Texture2D;
@export var collsion_shape:Shape2D;
@export var animte:SpriteFrames;
@export var name:String;
@export var speed:int;
@export var cooldown:int = 5;


@export_group("rotation_degress")
@export var rotation_degress_left:float;
@export var rotation_degress_right:float;
@export var rotation_degress_front:float;
@export var rotation_degress_back:float;

func _get_rotation_degress(direction:Vector2):
	if direction == Vector2.LEFT:
		return rotation_degress_left;
	elif direction == Vector2.RIGHT:
		return rotation_degress_right;
	elif direction == Vector2.DOWN:
		return rotation_degress_front;
	elif direction == Vector2.UP:
		return rotation_degress_back;
