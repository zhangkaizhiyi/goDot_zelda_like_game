extends Node2D
@onready var marker_2d: Marker2D = $Marker2D
const PLAYER_SCENE = preload("res://scene/player/player.tscn")



func _ready() -> void:
	var player:Player = PLAYER_SCENE.instantiate();
	player.global_position = marker_2d.global_position;
	add_child(player);
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scene/main_scene.tscn")
