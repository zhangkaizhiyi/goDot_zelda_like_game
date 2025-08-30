class_name InventoryItemCell
extends VBoxContainer

@onready var texture_rect: TextureRect = $Container/TextureRect
@onready var lb_stack: Label = $Container/lbStack
@onready var lb_name: Label = $lbName
@onready var menu_button: MenuButton = $Container/MenuButton


@export var current_inventory_item:InventoryItem;
@export var is_empty = true; 


func _ready() -> void:
	menu_button.disabled = true;
	var popup = menu_button.get_popup()
	popup.id_pressed.connect(_on_menu_item_pressed)


func _on_menu_item_pressed(id):
	if id == 1:
		InventoryManager.equip_weapon(current_inventory_item);
	elif id == 2:
		print("Start Game selected")
	elif id == 3:
		print("drop")
	
	
func add_item(inventory_item:InventoryItem):
	current_inventory_item = inventory_item;
	
	texture_rect.texture = inventory_item.texture;
	lb_name.text = inventory_item.name;
	is_empty = false;
	menu_button.disabled = false;
	var popup = menu_button.get_popup()
	if inventory_item is WeaponItem:
		popup.add_item("epuip", 1)
	popup.add_item("drop", 3)
	
