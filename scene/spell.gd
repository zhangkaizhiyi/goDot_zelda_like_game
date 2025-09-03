class_name Spell
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var current_spell_item:SpellItem;

@export var speed:int;
@export var move_direction:Vector2;

func set_config(spell_item:SpellItem,direction:Vector2) -> void:
	current_spell_item = spell_item;
	animated_sprite_2d.sprite_frames = spell_item.animte;
	collision_shape_2d.shape = spell_item.collsion_shape;
	move_direction = direction;
	speed = spell_item.speed;

func _process(delta: float) -> void:
	position += speed * move_direction * delta;
