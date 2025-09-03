class_name InventoryItemCell
extends VBoxContainer

@onready var texture_rect: TextureRect = $Container/TextureRect
@onready var lb_stack: Label = $Container/lbStack
@onready var lb_name: Label = $lbName
@onready var menu_button: MenuButton = $Container/MenuButton
@onready var button: Button = $Container/Button


@export var current_inventory_item:InventoryItem;
@export var current_spell_item:SpellItem;
@export var is_empty = true; 
@export var type:DataType.InventoryItemType = DataType.InventoryItemType.InventorySlot;

signal sg_click(spell:SpellItem);

func _ready() -> void:
	change_style();
	menu_button.disabled = true;
	var popup = menu_button.get_popup()
	popup.id_pressed.connect(_on_menu_item_pressed)

func change_style():
	if type == DataType.InventoryItemType.InventorySlot:
		menu_button.visible = true;
		button.visible = false;
	elif type == DataType.InventoryItemType.Spell:
		button.visible = true;
		menu_button.visible = false;
	elif type == DataType.InventoryItemType.Display:
		button.visible = false;
		menu_button.visible = false;
		
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
	button.disabled = true;
	var popup = menu_button.get_popup()
	if inventory_item is WeaponItem:
		popup.add_item("epuip", 1)
	popup.add_item("drop", 3)
	
func add_spell(spell_item:SpellItem):
	current_spell_item = spell_item;
	texture_rect.texture = spell_item.texture;
	lb_name.text = spell_item.name;
	
	

func _on_button_pressed() -> void:
	sg_click.emit(current_spell_item);
