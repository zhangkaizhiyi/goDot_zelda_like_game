extends CanvasLayer
@onready var grid_container: GridContainer = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/GridContainer
@onready var spell_container: VBoxContainer = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/SpellContainer
@onready var spell_cell_0: InventoryItemCell = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/SpellContainer/HBoxContainer/InventoryItemCell
@onready var spell_cell_1: InventoryItemCell = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/SpellContainer/HBoxContainer/InventoryItemCell2
@onready var spell_cell_2: InventoryItemCell = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/ScrollContainer/VBoxContainer/SpellContainer/HBoxContainer/InventoryItemCell3



var inventory_item_scene = preload("res://ui/inventory_item_cell.tscn")
@export var slot_num = 8;
@export var spell_array : Array[SpellItem] = [
	preload('res://resource/spell/ice/ice_spell_item.tres'),
	preload('res://resource/spell/fire/fire_spell_item.tres'),
	preload('res://resource/spell/plant/plant_spell_item.tres'),
];



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		toggleDisplay();


func toggleDisplay():
	visible = !visible;


func _ready() -> void:
	for i in slot_num:
		var inventory_item:InventoryItemCell = inventory_item_scene.instantiate();
		grid_container.add_child(inventory_item);
	spell_cell_0.add_spell(spell_array[0]);
	spell_cell_1.add_spell(spell_array[1]);
	spell_cell_2.add_spell(spell_array[2]);
	
	spell_cell_0.sg_click.connect(on_sg_click);
	spell_cell_1.sg_click.connect(on_sg_click);
	spell_cell_2.sg_click.connect(on_sg_click);
	InventoryManager.sg_inventory_add_item.connect(on_inventory_add_item);
	InventoryManager.sg_inventory_remove_item.connect(on_inventory_remove_item);
	InventoryManager.sg_weapon_change.connect(on_weapon_change);

func on_inventory_add_item(item:InventoryItem):
	var itemCells = grid_container.get_children();
	for i in itemCells.size():
		var itemCell:InventoryItemCell = itemCells[i] as InventoryItemCell;
		if itemCell.is_empty or itemCell.current_inventory_item.name == item.name:
			itemCell.add_item(item);
			return;
			
func on_inventory_remove_item(item:InventoryItem):
	var itemCells = grid_container.get_children();
	for i in itemCells.size():
		var itemCell:InventoryItemCell = itemCells[i] as InventoryItemCell;
		if itemCell.current_inventory_item.name == item.name:
			itemCell.remove_item(item);
			return;		
	
	
func on_weapon_change(weapon:WeaponItem):
	if weapon.weapon_type == DataType.WeaponType.Magic:
		spell_container.visible = true;
	else:
		spell_container.visible = false;
		
func on_sg_click(spell:SpellItem):
	InventoryManager.equip_spell(spell);
