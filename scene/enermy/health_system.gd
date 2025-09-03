class_name HealthSystem
extends Node

@export var health:int = 100;
@export var max_health:int = 100;

signal die;
signal health_change;

func apply_damage(damage:int):
	health -= damage;
	if health <= 0:
		die.emit();
