class_name WeaponItem
extends InventoryItem




@export var weapon_type:DataType.WeaponType;
@export var texture_in_hand:Texture
@export var collsion_shape_in_hand:Shape2D;
@export_group('rotation_degress')
@export var texture_rotation_degress_left :float;
@export var texture_rotation_degress_right :float;
@export var texture_rotation_degress_front :float;
@export var texture_rotation_degress_back:float;
@export_group('texture_position')
@export var texture_position_left:Vector2;
@export var texture_position_right:Vector2;
@export var texture_position_front:Vector2;
@export var texture_position_back:Vector2;



func texture_rotation_degress(direction:Vector2):
	if direction == Vector2.LEFT:
		return texture_rotation_degress_left;
	elif direction == Vector2.RIGHT:
		return texture_rotation_degress_right;
	elif direction == Vector2.DOWN:
		return texture_rotation_degress_front;
	elif direction == Vector2.UP:
		return texture_rotation_degress_back;

func texture_position(direction:Vector2):
	if direction == Vector2.LEFT:
		return texture_position_left;
	elif direction == Vector2.RIGHT:
		return texture_position_right;
	elif direction == Vector2.DOWN:
		return texture_position_front;
	elif direction == Vector2.UP:
		return texture_position_back;
