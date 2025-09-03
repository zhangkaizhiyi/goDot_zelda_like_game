extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


@export var inventory_item:InventoryItem;

func _ready() -> void:
	sprite_2d.texture = inventory_item.texture;
	collision_shape_2d.shape = inventory_item.collsion_shape;



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		InventoryManager.add_item(inventory_item,1);
		queue_free();
		
