extends CanvasLayer

@onready var grid_container: GridContainer = $ColorRect/MarginContainer/NinePatchRect/MarginContainer/VBoxContainer/GridContainer


var inventory_item_scene = preload("res://ui/inventory_item_cell.tscn")
@export var slot_num = 8;




func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		toggleDisplay();


func toggleDisplay():
	visible = !visible;


func _ready() -> void:
	for i in slot_num:
		var inventory_item:InventoryItemCell = inventory_item_scene.instantiate();
		grid_container.add_child(inventory_item);
	InventoryManager.sg_inventory_size_change.connect(on_inventory_size_change);

func on_inventory_size_change(item:InventoryItem,size:int):
	var itemCells = grid_container.get_children();
	for i in itemCells.size():
		var itemCell:InventoryItemCell = itemCells[i] as InventoryItemCell;
		if itemCell.is_empty:
			itemCell.add_item(item);
			return;
	
