#01. @tool

#02. class_name

#03. extends
extends Node
#04. # docstring

## hoge

#region Signal, Enum, Const
#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------



#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------



#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------



#endregion
#-----------------------------------------------------------

#region Variable
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

@export_category("リソース")

## 表示テキスト、アイコンを上書き
@export var item_id:int = -1
var item:Item

## 表示テキスト、アイコンを上書き
@export var element_id:int = -1
var element:Element

@export var icon_texture:Texture2D = null

var resource_type:int
const RESOURCE_TYPE_ELEMENT:int = 0
const RESOURCE_TYPE_SKILL:int = 1
const RESOURCE_TYPE_ITEM:int = 2
const RESOURCE_TYPE_ICON:int = 3
const RESOURCE_TYPE_NONE:int = 3

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

@onready var margin_container:MarginContainer = get_node_or_null("%MarginContainer")
@onready var center_container:CenterContainer = get_node_or_null("%CenterContainer")
@onready var icon_margin_container: MarginContainer = get_node_or_null("%IconMarginContainer")
@onready var icon_texture_rect: TextureRect = get_node_or_null("%IconTextureRect")

@onready var label:Label = %Label
@onready var label_2:Label = get_node_or_null("%Label2")

@onready var hp_gauge: BattleUIGauge = get_node_or_null("%HpGauge")
@onready var mp_gauge: BattleUIGauge = get_node_or_null("%MpGauge")
@onready var tp_gauge_1: BattleUIGauge = get_node_or_null("%TpGauge1")
@onready var tp_gauge_2: BattleUIGauge = get_node_or_null("%TpGauge2")

#endregion
#-----------------------------------------------------------

#region _init, _ready
#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------



#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _ready():
	if element_id != -1:
		element = Dbs.find_element_by_id(element_id)
		icon_texture_rect.texture = ImageLoader.get_icon(element.icon)
		resource_type = RESOURCE_TYPE_ELEMENT
		label.text = element.name
	if resource_type == RESOURCE_TYPE_ITEM:
		visible = false
		# set_itemで設定する
	elif icon_texture:
		icon_texture_rect.texture = icon_texture
		resource_type = RESOURCE_TYPE_NONE
		icon_texture_rect.visible = true
		if icon_margin_container:
			icon_margin_container.visible = true
		if label:
			assert(command_name)
			label.text = command_name
	else:
		if icon_texture_rect:
			icon_texture_rect.texture = null
			icon_texture_rect.visible = false
		if icon_margin_container:
			icon_margin_container.visible = false
		if label:
			label.text = command_name


			#if margin_container != null:
	##			margin_container.size = Vector2.ZERO
				#pass
			#if center_container != null:
	##			center_container.size = Vector2.ZERO
				#pass
	
	if label:
		label.pivot_offset = label.size / 2
	if label_settings:
		label.label_settings = label_settings

	if center_position:
		center_position.position = size / 2
		if center_position.has_node("ParticlesWrap"):
			particles = center_position.get_node("ParticlesWrap")

	if !Engine.is_editor_hint():
		resize.call_deferred()



#endregion
#-----------------------------------------------------------

#region _virtual Function
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------



#endregion
#-----------------------------------------------------------

#region Public Function
#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------



#endregion
#-----------------------------------------------------------

#region _private Function
#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------

func _focus_enter() -> void:
	if disabled: return
	focus_mode = Control.FOCUS_ALL
	grab_focus.call_deferred()
	safe_focus_entered.emit()
	_focus_enter()
	if is_anim and animation_player.is_playing():
		animation_player.advance(animation_player.current_animation_length)
	if is_audio:
		play_sound(focus_sound)
	if is_anim and animation_player.has_animation("focus_entered"):
		animation_player.clear_queue()
		animation_player.play("focus_entered")
		if particles != null:
			particles.emit_start()
		if animation_player.has_animation("focusing"):
			animation_player.queue("focusing")
	else:
		animation_player.clear_queue()
		animation_player.play("RESET")
		if particles != null:
			particles.emit_stop()

func _focus_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	if disabled: return
	#texture_normal = _texture_normal
	#add_theme_stylebox_override("normal", normal_style)
	focus_mode = Control.FOCUS_NONE
	safe_focus_exited.emit()
	if is_anim and animation_player.is_playing():
		animation_player.advance(animation_player.current_animation_length)
	if is_anim and animation_player.has_animation("focus_exited"):
		animation_player.clear_queue()
		animation_player.play("focus_exited")
		if particles != null:
			particles.emit_stop()

	else:
		animation_player.clear_queue()
		animation_player.play("RESET")
		if particles != null:
			particles.emit_stop()

func _hover_enter() -> void:
	if disabled: return
	safe_hover_entered.emit()
	_hover_enter()
	if is_anim and animation_player.is_playing():
		animation_player.advance(animation_player.current_animation_length)
	if is_audio:
		play_sound(focus_sound)
	if is_anim and animation_player.has_animation("hover_entered"):
		animation_player.clear_queue()
		animation_player.play("hover_entered")
		if particles != null:
			particles.emit_start()
		if animation_player.has_animation("hovering"):
			animation_player.queue("hovering")
	else:
		animation_player.clear_queue()
		animation_player.play("RESET")
		if particles != null:
			particles.emit_stop()

func __hover_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	if disabled: return
	safe_hover_exited.emit()
	_hover_exit()
	if is_anim and animation_player.is_playing():
		animation_player.advance(animation_player.current_animation_length)
	if is_anim and animation_player.has_animation("hover_exited"):
		animation_player.clear_queue()
		animation_player.play("hover_exited")
		if particles != null:
			particles.emit_stop()
	else:
		animation_player.clear_queue()
		animation_player.play("RESET")
		if particles != null:
			particles.emit_stop()

func resize() -> void:
	self.custom_minimum_size = margin_container.size

func set_item(item:Item, data:Dictionary) -> void:
	if resource_type == RESOURCE_TYPE_ITEM:
		#icon_texture_rect.texture = item.icon#TODO
		resource_type = RESOURCE_TYPE_ITEM
		label.text = item.name
		label_2.text = str(data["count"])
		visible = true
		icon_texture_rect.visible = true
		self.item = item
		self.item_data = data
		if icon_margin_container:
			icon_margin_container.visible = true
		
		# アイテムは新アイテムはNEWをつける TODO
		
		resize.call_deferred()

func update_text(new_text:String) -> void:
	if label:
		command_name = new_text
		label.text = new_text

func set_character_info(chara_info:CharacterInfo) -> void:
	#set_b_chara(chara_info.b_chara)
	data_id = str(chara_info.id)

func set_b_chara(chara:BChara) -> void:
	if chara == null:
		data_id = &""
		label.text = ""
		if hp_gauge:
			hp_gauge.visible = false
		if mp_gauge:
			mp_gauge.visible = false
		if tp_gauge_1:
			tp_gauge_1.visible = false
		if tp_gauge_2:
			tp_gauge_2.visible = false
		return
	data_id = str(chara.bid)
	if label:
		command_name = chara.name
		label.text = chara.name
	
	if icon_texture_rect and chara.image:
		#icon_texture_rect.texture = chara.image #TODO
		pass
	if hp_gauge:
		hp_gauge.visible = true
		hp_gauge.init(chara.hp, chara.max_hp)
	if mp_gauge:
		mp_gauge.visible = true
		mp_gauge.init(chara.mp, chara.max_mp)
	if tp_gauge_1:
		tp_gauge_1.visible = true
		tp_gauge_1.init(chara.mp, chara.max_mp)
	if tp_gauge_2:
		tp_gauge_2.visible = true
		tp_gauge_2.init(chara.mp, chara.max_mp)


#endregion
#-----------------------------------------------------------

