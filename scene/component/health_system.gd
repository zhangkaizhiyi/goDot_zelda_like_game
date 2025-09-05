class_name HealthSystem
extends Node

@export var health:int = 100;
@export var max_health:int = 100;

signal die;
signal sg_health_change(health:int);

func apply_damage(damage:int):
	health -= damage;
	if health <= 0:
		health = 0;
	sg_health_change.emit(health);
	if health == 0:
		die.emit();
