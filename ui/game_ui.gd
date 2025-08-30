extends CanvasLayer
@onready var left_hand_solt: InventoryItemCell = $MarginContainer/HBoxContainer/LeftHandSolt
@onready var right_hand_solt: InventoryItemCell = $MarginContainer/HBoxContainer/RightHandSolt
@onready var potion_solt: InventoryItemCell = $MarginContainer/HBoxContainer/PotionSolt


func _ready() -> void:
	InventoryManager.sg_weapon_change.connect(on_weapon_change);

func on_weapon_change(weapon:WeaponItem):
	left_hand_solt.add_item(weapon);
