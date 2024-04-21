##-----------------------------------------------------------
##01. tool
##-----------------------------------------------------------
#@tool
##-----------------------------------------------------------
##02. class_name
##-----------------------------------------------------------
#class_name Command
#
##-----------------------------------------------------------
##03. extends
##-----------------------------------------------------------
#extends Button
#
##-----------------------------------------------------------
##04. # docstring
### Button
### CommandListのコマンドリストArrayにセットするテキストコマンド。
### アイコンもあるよ
##-----------------------------------------------------------
#
##-----------------------------------------------------------
##05. signals
##-----------------------------------------------------------
#signal safe_pressed
#signal safe_focus_entered
#signal safe_focus_exited
#signal safe_hover_entered
#signal safe_hover_exited
#
##-----------------------------------------------------------
##06. enums
##-----------------------------------------------------------
#
##-----------------------------------------------------------
##07. constants
##-----------------------------------------------------------
#
##-----------------------------------------------------------
##08. exported variables
##-----------------------------------------------------------
#
### 表示テキスト
#@export var command_name:String = "" # (String, MULTILINE)
#
### 画面で一意のIDを設定すると便利
#@export var data_id: StringName = &""
#
#@export var label_settings:LabelSettings = null
#
#@export var focus_sound:StringName = &"cursor_move_0"
#
#@export var press_sound:StringName = &"accept"
#
### 空状態（選択できない・表示できない）
#@export var is_empty:bool = false
#
#@export_category("リソース")
#
### 表示テキスト、アイコンを上書き
#@export var item_id:int = -1
#var item:Item
#
### 表示テキスト、アイコンを上書き
#@export var element_id:int = -1
#var element:Element
#
#@export var icon_texture:Texture2D = null
##-----------------------------------------------------------
##09. public variables
##-----------------------------------------------------------
#var command_list
#
#var resource_type:int
#const RESOURCE_TYPE_ELEMENT = 0
#const RESOURCE_TYPE_SKILL = 1
#const RESOURCE_TYPE_ITEM = 2
#const RESOURCE_TYPE_ICON = 3
#const RESOURCE_TYPE_NONE = 3
#
##-----------------------------------------------------------
##10. private variables
##-----------------------------------------------------------
#
### アイテムの所持数とか
#var item_data:Dictionary
##-----------------------------------------------------------
##11. onready variables
##-----------------------------------------------------------
#@onready var animation_player:AnimationPlayer = get_node_or_null("%AnimationPlayer")
#
#@onready var margin_container:MarginContainer = get_node_or_null("%MarginContainer")
#@onready var center_container:CenterContainer = get_node_or_null("%CenterContainer")
#@onready var icon_margin_container: MarginContainer = get_node_or_null("%IconMarginContainer")
#@onready var icon_texture_rect: TextureRect = get_node_or_null("%IconTextureRect")
#
#@onready var label:Label = %Label
#@onready var label_2:Label = get_node_or_null("%Label2")
#
#@onready var hp_gauge: BattleUIGauge = get_node_or_null("%HpGauge")
#@onready var mp_gauge: BattleUIGauge = get_node_or_null("%MpGauge")
#@onready var tp_gauge_1: BattleUIGauge = get_node_or_null("%TpGauge1")
#@onready var tp_gauge_2: BattleUIGauge = get_node_or_null("%TpGauge2")
#
##@onready var focus_sound:AudioStreamPlayer = get_node_or_null("%FocusSound")
##@onready var press_sound:AudioStreamPlayer = get_node_or_null("%PressSound")
#@onready var center_position = get_node_or_null("%CenterPosition")
#
#var particles = null
#
#var normal_style:StyleBox
#var focus_style:StyleBox
#
##@onready var _texture_normal:Texture2D = texture_normal
##@onready var _texture_focused:Texture2D = texture_focused
##@onready var _texture_pressed:Texture2D = texture_pressed
##@onready var _texture_hover:Texture2D = texture_hover
#
#var safe_disabled:bool = false
#
#var ready_frame_timer := FrameTimer.new()
#const ready_timer_wait_frames:int = 1
#var click_timer := Timer.new()
#var safe_delay_sec:float = 0.1
#
#var focus_neighbor_top_default:NodePath = NodePath("")
#var focus_neighbor_left_default:NodePath = NodePath("")
#var focus_neighbor_right_default:NodePath = NodePath("")
#var focus_neighbor_bottom_default:NodePath = NodePath("")
#
##-----------------------------------------------------------
##12. optional built-in virtual _init method
##-----------------------------------------------------------
#
#func _init() -> void:
	#focus_mode = FOCUS_NONE
#
##-----------------------------------------------------------
##13. built-in virtual _ready method
##-----------------------------------------------------------
#
#func _ready() -> void:
	#pressed.connect(_on_pressed)
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)
	#focus_entered.connect(_on_focus_entered)
	#focus_exited.connect(_on_focus_exited)
	#add_child(click_timer)
	#click_timer.one_shot = true
	#add_child(ready_frame_timer)
	#ready_frame_timer.wait_frames = ready_timer_wait_frames
	#ready_frame_timer.one_shot = true
	#normal_style = self.get_theme_stylebox("normal")
	#focus_style = self.get_theme_stylebox("focus")
	#
	#focus_neighbor_top_default = focus_neighbor_top
	#focus_neighbor_left_default = focus_neighbor_left
	#focus_neighbor_right_default = focus_neighbor_right
	#focus_neighbor_bottom_default = focus_neighbor_bottom
	#
	#safe_disabled = disabled
	#
	#if element_id != -1:
		#element = Dbs.find_element_by_id(element_id)
		#icon_texture_rect.texture = ImageLoader.get_icon(element.icon)
		#resource_type = RESOURCE_TYPE_ELEMENT
		#label.text = element.name
	#if resource_type == RESOURCE_TYPE_ITEM:
		#visible = false
		## set_itemで設定する
	#elif icon_texture:
		#icon_texture_rect.texture = icon_texture
		#resource_type = RESOURCE_TYPE_NONE
		#icon_texture_rect.visible = true
		#if icon_margin_container:
			#icon_margin_container.visible = true
		#if label:
			#assert(command_name)
			#label.text = command_name
	#else:
		#if icon_texture_rect:
			#icon_texture_rect.texture = null
			#icon_texture_rect.visible = false
		#if icon_margin_container:
			#icon_margin_container.visible = false
		#if label:
			#label.text = command_name
#
#
			##if margin_container != null:
	###			margin_container.size = Vector2.ZERO
				##pass
			##if center_container != null:
	###			center_container.size = Vector2.ZERO
				##pass
	#
	#if label:
		#label.pivot_offset = label.size / 2
	#if label_settings:
		#label.label_settings = label_settings
#
	#if center_position:
		#center_position.position = size / 2
		#if center_position.has_node("ParticlesWrap"):
			#particles = center_position.get_node("ParticlesWrap")
#
	#if !Engine.is_editor_hint():
		#resize.call_deferred()
	#pivot_offset = size / 2
	#
	#safe_disabled = true
	#ready_frame_timer.start()
	#await ready_frame_timer.timeout
	#safe_disabled = false
#
##-----------------------------------------------------------
##14. remaining built-in virtual methods
##-----------------------------------------------------------
#func _on_pressed() -> void:
	#if safe_disabled: 
		#print("SAFE GUARD:", click_timer.time_left)
		#set_focus_enter()
		#return
	#if disabled:
		#set_focus_enter()
		#return
	##texture_normal = _texture_pressed
	#AudioSystem.play_sound(press_sound)
	#if animation_player.has_animation("pressed"):
		#animation_player.clear_queue()
		#animation_player.play("pressed")
	#
	#safe_pressed.emit()
	#
	#safe_disabled = true
	#click_timer.start(safe_delay_sec)
	#await click_timer.timeout
	#safe_disabled = false
##	await animation_player.animation_finished
##	animation_player.play("RESET")
#
#func _on_focus_entered() -> void:
	#
	#pass
#
#func _on_focus_exited() -> void:
	#
	#pass
#
#func _focus_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	#if disabled: return
	##texture_normal = _texture_focused
	#focus_mode = Control.FOCUS_ALL
	#grab_focus.call_deferred()
	##add_theme_stylebox_override("normal", focus_style)
	#safe_focus_entered.emit()
	#if is_anim and animation_player.is_playing():
		#animation_player.advance(animation_player.current_animation_length)
	#if is_audio:
		#AudioSystem.play_sound(focus_sound)
	#if is_anim and animation_player.has_animation("focus_entered"):
		#animation_player.clear_queue()
		#animation_player.play("focus_entered")
		#if particles != null:
			#particles.emit_start()
		#if animation_player.has_animation("focusing"):
			#animation_player.queue("focusing")
	#else:
		#animation_player.clear_queue()
		#animation_player.play("RESET")
		#if particles != null:
			#particles.emit_stop()
#
#func _focus_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	#if disabled: return
	##texture_normal = _texture_normal
	##add_theme_stylebox_override("normal", normal_style)
	#focus_mode = Control.FOCUS_NONE
	#safe_focus_exited.emit()
	#if is_anim and animation_player.is_playing():
		#animation_player.advance(animation_player.current_animation_length)
	#if is_anim and animation_player.has_animation("focus_exited"):
		#animation_player.clear_queue()
		#animation_player.play("focus_exited")
		#if particles != null:
			#particles.emit_stop()
#
	#else:
		#animation_player.clear_queue()
		#animation_player.play("RESET")
		#if particles != null:
			#particles.emit_stop()
#
#func _hover_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	#if disabled: return
	##texture_normal = _texture_focused
	#safe_hover_entered.emit()
	#if is_anim and animation_player.is_playing():
		#animation_player.advance(animation_player.current_animation_length)
	#if is_audio:
		#AudioSystem.play_sound(focus_sound)
	#if is_anim and animation_player.has_animation("hover_entered"):
		#animation_player.clear_queue()
		#animation_player.play("hover_entered")
		#if particles != null:
			#particles.emit_start()
		#if animation_player.has_animation("hovering"):
			#animation_player.queue("hovering")
	#else:
		#animation_player.clear_queue()
		#animation_player.play("RESET")
		#if particles != null:
			#particles.emit_stop()
#
#func _hover_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	#if disabled: return
	##texture_normal = _texture_normal
	#safe_hover_exited.emit()
	#if is_anim and animation_player.is_playing():
		#animation_player.advance(animation_player.current_animation_length)
	#if is_anim and animation_player.has_animation("hover_exited"):
		#animation_player.clear_queue()
		#animation_player.play("hover_exited")
		#if particles != null:
			#particles.emit_stop()
	#else:
		#animation_player.clear_queue()
		#animation_player.play("RESET")
		#if particles != null:
			#particles.emit_stop()
#
#func _on_mouse_entered() -> void:
	#_hover_enter(true, false)
#
#func _on_mouse_exited() -> void:
	#_hover_exit(false)
#
##-----------------------------------------------------------
##15. public methods
##-----------------------------------------------------------
#
#func set_empty_mode(is_empty_) -> void:
	#is_empty = is_empty_
	#visible = !is_empty
#
#func resize() -> void:
	#self.custom_minimum_size = margin_container.size
#
#func set_item(item:Item, data:Dictionary) -> void:
	#if resource_type == RESOURCE_TYPE_ITEM:
		##icon_texture_rect.texture = item.icon#TODO
		#resource_type = RESOURCE_TYPE_ITEM
		#label.text = item.name
		#label_2.text = str(data["count"])
		#visible = true
		#icon_texture_rect.visible = true
		#self.item = item
		#self.item_data = data
		#if icon_margin_container:
			#icon_margin_container.visible = true
		#
		## アイテムは新アイテムはNEWをつける TODO
		#
		#resize.call_deferred()
#
#func set_focus_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	#_focus_enter(is_anim,is_audio)
#
#func set_focus_exit(is_anim:bool = true, is_audio:bool = true) -> void:
	#_focus_exit(is_anim,is_audio)
#
#func update_text(new_text:String) -> void:
	#if label:
		#command_name = new_text
		#label.text = new_text
#
#func set_character_info(chara_info:CharacterInfo) -> void:
	##set_b_chara(chara_info.b_chara)
	#data_id = str(chara_info.id)
#
#func set_b_chara(chara:BChara) -> void:
	#if chara == null:
		#data_id = &""
		#label.text = ""
		#if hp_gauge:
			#hp_gauge.visible = false
		#if mp_gauge:
			#mp_gauge.visible = false
		#if tp_gauge_1:
			#tp_gauge_1.visible = false
		#if tp_gauge_2:
			#tp_gauge_2.visible = false
		#return
	#data_id = str(chara.bid)
	#if label:
		#command_name = chara.name
		#label.text = chara.name
	#
	#if icon_texture_rect and chara.image:
		##icon_texture_rect.texture = chara.image #TODO
		#pass
	#if hp_gauge:
		#hp_gauge.visible = true
		#hp_gauge.init(chara.hp, chara.max_hp)
	#if mp_gauge:
		#mp_gauge.visible = true
		#mp_gauge.init(chara.mp, chara.max_mp)
	#if tp_gauge_1:
		#tp_gauge_1.visible = true
		#tp_gauge_1.init(chara.mp, chara.max_mp)
	#if tp_gauge_2:
		#tp_gauge_2.visible = true
		#tp_gauge_2.init(chara.mp, chara.max_mp)
	#
##-----------------------------------------------------------
##16. private methods
##-----------------------------------------------------------
#
