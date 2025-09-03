# 而全局的模式相当于单例，可以全局共享
extends Node

@export var items:Array[InventoryItem] = [];
@export var max_size = 100;
@export var current_weapon:WeaponItem;
@export var current_spell:SpellItem;


signal sg_inventory_size_change(item:InventoryItem,size:int);
signal sg_weapon_change(weapon:WeaponItem);
signal sg_spell_change(spell:SpellItem);
signal sg_spell_cooldown(cool_down_timer:int);

func equip_weapon(weapon:WeaponItem):
	current_weapon = weapon;
	sg_weapon_change.emit(weapon);

func equip_spell(spell:SpellItem):
	current_spell = spell;
	sg_spell_change.emit(spell);


func add_item(item:InventoryItem,size:int):
	if items.size() + size > max_size :
		pass
	else:
		items.append(item);
		sg_inventory_size_change.emit(item,size);
		
		
func remove_item(item:InventoryItem):
	items.append(item);
