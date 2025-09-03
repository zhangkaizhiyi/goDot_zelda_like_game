class_name Enermy
extends CharacterBody2D

enum EnemyState{
	walk,
	idle
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var move_path_array:Array[Marker2D];
@export var speed = 10;
@export var current_target_index = 0;
@export var face_direction:Vector2;
@export var current_state = EnemyState.walk;

var wait_timer:Timer;


func _ready() -> void:
	wait_timer = Timer.new();
	wait_timer.wait_time = 5;
	wait_timer.one_shot = true;
	add_child(wait_timer);
	wait_timer.timeout.connect(on_wait_timer_timeout);

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
		
	
	

func on_wait_timer_timeout():
	change_state(EnemyState.walk);


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
