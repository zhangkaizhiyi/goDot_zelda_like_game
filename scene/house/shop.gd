extends Node2D

@onready var house_inner: TileMapLayer = $houseInner
@onready var house_outer: TileMapLayer = $houseOuter




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		house_outer.visible = false;
		house_outer.collision_enabled = false;
		house_inner.visible = true;
