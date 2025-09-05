class_name Enermy
extends CharacterBody2D

enum EnemyState{
	walk,
	idle
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_system: HealthSystem = $HealthSystem

@export var move_path_array:Array[Marker2D];
@export var speed:int = 10;
@export var current_target_index:int = 0;
@export var face_direction:Vector2;
@export var current_state: = EnemyState.walk;
@export var damage:int = 10;
var wait_timer:Timer;
const PICKUP_ITEM = preload("res://scene/pickupItem/pickup_item.tscn")

func _ready() -> void:
	wait_timer = Timer.new();
	wait_timer.wait_time = 5;
	wait_timer.one_shot = true;
	add_child(wait_timer);
	wait_timer.timeout.connect(on_wait_timer_timeout);
	
	progress_bar.visible = false;
	progress_bar.max_value = health_system.max_health;
	progress_bar.value = health_system.health;
	health_system.die.connect(on_die);
	health_system.sg_health_change.connect(on_health_change);

func _physics_process(delta: float) -> void:
	var distance = global_position.distance_to(move_path_array[current_target_index].global_position);
	var target_position = move_path_array[current_target_index].global_position;
	face_direction = (target_position - global_position).normalized()
	
	if distance <= 1:
		current_target_index = (current_target_index + 1) % move_path_array.size();
		change_state(EnemyState.idle);
		wait_timer.start();
	
	if current_state == EnemyState.idle:
		return;
	
	
	velocity = speed * face_direction;
	move_and_slide();
		
################OB#######################
func on_wait_timer_timeout():
	change_state(EnemyState.walk);
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	EventBus.sg_cause_damage.emit(damage);

func on_die():
	animated_sprite_2d.play('die');
	await animated_sprite_2d.animation_finished
	queue_free();
	var pickup_item:Pickup = PICKUP_ITEM.instantiate();
	pickup_item.inventory_item = load("res://resource/inventory_item/gold/gold_inventory_item.tres");
	pickup_item.global_position = global_position;
	get_tree().root.add_child(pickup_item);

func on_health_change(health:int):
	progress_bar.visible = true;
	progress_bar.value = health;

################  State #######################
func change_state(state:EnemyState):
	print("current state:",state);
	if current_state == state:
		return;
	current_state = state;
	if current_state == EnemyState.idle:
		play_idle_animate(face_direction);
	elif current_state == EnemyState.walk:
		play_walk_animate(face_direction);
	
func play_walk_animate(direction:Vector2):
	var absx = absf(direction.x);
	var absy = absf(direction.y);
	
	if direction.x > 0:
		if absx >= absy:
			animated_sprite_2d.play('walk_right')
		elif direction.y < 0:
			animated_sprite_2d.play('walk_back')
		else:
			animated_sprite_2d.play('walk_front')
	else:
		if absx >= absy:
			animated_sprite_2d.play('walk_left')
		elif direction.y < 0:
			animated_sprite_2d.play('walk_back')
		else:
			animated_sprite_2d.play('walk_front')
	
func play_idle_animate(direction:Vector2):
	var absx = absf(direction.x);
	var absy = absf(direction.y);
	if direction.x > 0:
		if absx >= absy:
			animated_sprite_2d.play('idle_right')
		elif direction.y < 0:
			animated_sprite_2d.play('idle_back')
		else:
			animated_sprite_2d.play('idle_front')
	else:
		if absx >= absy:
			animated_sprite_2d.play('idle_left')
		elif direction.y < 0:
			animated_sprite_2d.play('idle_back')
		else:
			animated_sprite_2d.play('idle_front')
