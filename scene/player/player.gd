class_name Player
extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Area2D = $Weapon
@onready var weapon_collision_shape_2d: CollisionShape2D = $Weapon/CollisionShape2D
@onready var weapon_sprite_2d: Sprite2D = $Weapon/Sprite2D
@export var health:int = 100;
@export var max_health:int = 100;
@export var speed:int = 50;

var face_direction:Vector2 = Vector2.ZERO;
var speed_direction:Vector2 = Vector2.ZERO;
enum PlayerState { IDLE, WALK, ATTACK }
var current_state = PlayerState.IDLE
var current_weapon:WeaponItem;

signal sg_spell_cast(spell:SpellItem);

func _ready() -> void:
	changeState(PlayerState.IDLE);
	animated_sprite_2d.animation_finished.connect(on_animation_finished);
	InventoryManager.sg_weapon_change.connect(on_weapon_change);
	InventoryManager.sg_weapon_unequip.connect(on_weapon_unequip);
	EventBus.sg_cause_damage.connect(on_cause_damage);
	
	await get_tree().physics_frame;
	var game_ui:GameUI = get_tree().get_first_node_in_group("GameUI");
	if game_ui != null:
		game_ui.set_health(health,max_health);
	

func on_cause_damage(damage:int):
	health -= damage;
	var game_ui:GameUI = get_tree().get_first_node_in_group("GameUI");
	game_ui.set_health(health,max_health);
	
	
func _physics_process(delta: float) -> void:
	if current_state == PlayerState.ATTACK:
		return;
		
	updateDirection();
	if speed_direction == Vector2.ZERO:
		changeState(PlayerState.IDLE)
	else:
		changeState(PlayerState.WALK)
		
	
	velocity = speed_direction * speed;
	move_and_slide();
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") && current_state != PlayerState.ATTACK:
		changeState(PlayerState.ATTACK)
		
func on_animation_finished():
	var anim_name = animated_sprite_2d.animation
	if anim_name.contains('attack'):
		changeState(PlayerState.IDLE)

func on_weapon_change(weapon:WeaponItem):
	current_weapon = weapon;
	weapon_sprite_2d.texture = current_weapon.texture_in_hand;
	weapon_collision_shape_2d.shape = current_weapon.collsion_shape;

func on_weapon_unequip():
	current_weapon = null;
	weapon_sprite_2d.texture = null;
	weapon_collision_shape_2d.shape = null;

func updateDirection():
	if Input.is_action_pressed("move_up"):
		face_direction = Vector2.UP;
		speed_direction = face_direction;
	elif Input.is_action_pressed("move_down"):
		face_direction = Vector2.DOWN;
		speed_direction = face_direction;
	elif Input.is_action_pressed("move_left"):
		face_direction = Vector2.LEFT;
		speed_direction = face_direction;
	elif Input.is_action_pressed("move_right"):
		face_direction = Vector2.RIGHT;
		speed_direction = face_direction;
	else:
		speed_direction = Vector2.ZERO;

func changeWalkAnimate(direction:Vector2):
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_back");
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front");
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left");
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right");
	else:
		animated_sprite_2d.play("walk_front");

func changeIdleAnimate(direction:Vector2):
	if direction == Vector2.UP:
		animated_sprite_2d.play("idle_back");
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front");
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left");
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("idle_right");
	else:
		animated_sprite_2d.play("idle_front");

func changeAttackAnimate(direction:Vector2):
	if direction == Vector2.UP:
		animated_sprite_2d.play("attack_back");
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("attack_front");
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("attack_left");
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("attack_right");
	else:
		animated_sprite_2d.play("attack_front");

func changeWeaponDisplay(direction:Vector2):
	var rotation:float = current_weapon.texture_rotation_degress(direction);
	var position:Vector2 = current_weapon.texture_position(direction);
	#prinDt("rotation",rotation);
	weapon.rotation = deg_to_rad(rotation);
	weapon.position = position;

func resetWeapon():
	weapon.rotation = deg_to_rad(0);
	weapon.position = Vector2.ZERO;

func changeState(state:PlayerState):
	if current_state == state:
		return;
	current_state = state;
	if current_state == PlayerState.IDLE:
		weapon.visible = false;
		resetWeapon();
		changeIdleAnimate(face_direction);
	elif current_state == PlayerState.WALK:
		weapon.visible = false;
		resetWeapon();
		changeWalkAnimate(face_direction)
	elif current_state == PlayerState.ATTACK:
		if current_weapon != null:
			weapon.visible = true;
			changeWeaponDisplay(face_direction);
		changeAttackAnimate(face_direction)
		if current_weapon == null:
			return;
		if current_weapon.weapon_type == DataType.WeaponType.Magic:
			if InventoryManager.current_spell != null:
				sg_spell_cast.emit(InventoryManager.current_spell);

func _on_weapon_body_entered(body: Node2D) -> void:
	if body.has_node('HealthSystem'):
		var health_system:HealthSystem = body.get_node('HealthSystem');
		health_system.apply_damage(current_weapon.damage);
