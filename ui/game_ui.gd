class_name GameUI
extends CanvasLayer
@onready var left_hand_solt: InventoryItemCell = $MarginContainer/HBoxContainer/LeftHandSolt
@onready var right_hand_solt: InventoryItemCell = $MarginContainer/HBoxContainer/RightHandSolt
@onready var potion_solt: InventoryItemCell = $MarginContainer/HBoxContainer/PotionSolt
@onready var magic_solt: InventoryItemCell = $MarginContainer/HBoxContainer/MagicSolt
@onready var color_rect: ColorRect = $MarginContainer/HBoxContainer/MagicSolt/Container/ColorRect
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar

func set_health(current_health:int,max_health:int):
	progress_bar.max_value = max_health;
	progress_bar.value = current_health;


func _ready() -> void:
	InventoryManager.sg_weapon_change.connect(on_weapon_change);
	InventoryManager.sg_spell_change.connect(on_spell_change);
	InventoryManager.sg_spell_cooldown.connect(on_spell_cooldown);

func on_weapon_change(weapon:WeaponItem):
	left_hand_solt.add_item(weapon);

func on_spell_change(spell:SpellItem):
	magic_solt.visible = true;
	magic_solt.add_spell(spell);
	
func on_spell_cooldown(cooldown_interval:int):
	var tween = get_tree().create_tween();
	tween.tween_property(color_rect,"size",Vector2(40,40),cooldown_interval);
	tween.tween_callback(on_spell_cooldown_finish);

func on_spell_cooldown_finish():
	color_rect.size.y = 0;
