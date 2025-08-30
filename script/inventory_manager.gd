extends Node

@export var items:Array[InventoryItem] = [];
@export var max_size = 100;
@export var current_weapon:WeaponItem;

signal sg_inventory_size_change(item:InventoryItem,size:int);
signal sg_weapon_change(weapon:WeaponItem);

func equip_weapon(weapon:WeaponItem):
	current_weapon = weapon;
	sg_weapon_change.emit(weapon);


func add_item(item:InventoryItem,size:int):
	if items.size() + size > max_size :
		pass
	else:
		items.append(item);
		sg_inventory_size_change.emit(item,size);
