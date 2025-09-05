class_name InventoryItemCell
extends VBoxContainer

@onready var texture_rect: TextureRect = $Container/TextureRect
@onready var lb_stack: Label = $Container/lbStack
@onready var lb_name: Label = $lbName
@onready var menu_button: MenuButton = $Container/MenuButton
@onready var button: Button = $Container/Button
const PICKUP_ITEM = preload("res://scene/pickupItem/pickup_item.tscn")

@export var current_inventory_item:InventoryItem;
@export var current_spell_item:SpellItem;
@export var is_empty:bool = true; 
@export var type:DataType.InventoryItemType = DataType.InventoryItemType.InventorySlot;

var item_size:int = 0;

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
		InventoryManager.drop_item(current_inventory_item);
	
	
func add_item(inventory_item:InventoryItem):
	item_size += 1;
	if item_size == 1:
		current_inventory_item = inventory_item;
		texture_rect.texture = inventory_item.texture;
		lb_name.text = inventory_item.name;
		menu_button.disabled = false;
		is_empty = false;
		button.disabled = true;
		var popup = menu_button.get_popup()
		if inventory_item is WeaponItem:
			popup.add_item("epuip", 1)
		popup.add_item("drop", 3)
	else:
		lb_stack.text = str(item_size);
	
func remove_weapon():
	current_inventory_item = null;
	texture_rect.texture = null;
	lb_name.text = "";
	menu_button.disabled = true;
	is_empty = true;
	button.disabled = false;
	lb_stack.text = "";
	
func remove_item(inventory_item:InventoryItem):
	var player:Player = get_tree().get_first_node_in_group("Player");
	var position = Vector2(player.global_position.x + 20,player.global_position.y + 20);
	var pickup:Pickup = PICKUP_ITEM.instantiate();
	pickup.inventory_item = inventory_item;
	get_tree().root.add_child(pickup);
	pickup.global_position = position;
	
	
	item_size -= 1;
	if item_size == 0:
		current_inventory_item = null;
		texture_rect.texture = null;
		lb_name.text = "";
		menu_button.disabled = true;
		is_empty = true;
		button.disabled = false;
		lb_stack.text = "";
	else:
		lb_stack.text = str(item_size);
	
	
func add_spell(spell_item:SpellItem):
	current_spell_item = spell_item;
	texture_rect.texture = spell_item.texture;
	lb_name.text = spell_item.name;
	
	

func _on_button_pressed() -> void:
	sg_click.emit(current_spell_item);
