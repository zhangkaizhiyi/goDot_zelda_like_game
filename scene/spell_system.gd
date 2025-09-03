class_name SpellSystem
extends Node
var spell_scene = preload("res://scene/spell.tscn");
var is_cool_down = false;
var timer = Timer.new();

func _ready() -> void:
	get_parent().sg_spell_cast.connect(on_spell_cast);
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true;

# 不能一直触发魔法攻击
func on_spell_cast(spell:SpellItem):
	if is_cool_down:
		return
	
	is_cool_down = true;
	timer.wait_time = spell.cooldown;
	timer.start();
	InventoryManager.sg_spell_cooldown.emit(spell.cooldown);
	
	
	
	var spellS:Spell = spell_scene.instantiate();
	spellS.global_position = get_parent().global_position;
	var spells = get_tree().root.get_node('MainScene/Spells');
	spells.add_child(spellS);
	
	var player:Player = get_parent();
	spellS.set_config(spell,player.face_direction);
	
	var rotation = spell._get_rotation_degress(player.face_direction)
	spellS.rotation_degrees = rotation;

func _on_timer_timeout():
	is_cool_down = false;
