#-----------------------------------------------------------
#01. tool
#-----------------------------------------------------------

#-----------------------------------------------------------
#02. class_name
#-----------------------------------------------------------
class_name FoltaUICommandHList

#-----------------------------------------------------------
#03. extends
#-----------------------------------------------------------
extends HBoxContainer

#-----------------------------------------------------------
#04. # docstring
## カッ・・・カッカッ・・・カカカカカってする
#-----------------------------------------------------------

#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal canceled
signal moved_focus
signal safe_pressed(id:StringName, control:Control)

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------

const KEY_UI_UP:StringName = &"ui_up"
const KEY_UI_DOWN:StringName = &"ui_down"
const KEY_UI_LEFT:StringName = &"ui_left"
const KEY_UI_RIGHT:StringName = &"ui_right"
const KEY_UI_ACCEPT:StringName = &"ui_accept"
const KEY_UI_CANCEL:StringName = &"ui_cancel"

const IS_JOYPAD_ENABLED:bool = true
const KEY_JOY_UP:StringName = &"joy_up"
const KEY_JOY_DOWN:StringName = &"joy_down"
const KEY_JOY_LEFT:StringName = &"joy_left"
const KEY_JOY_RIGHT:StringName = &"joy_right"

#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

## メニューが有効な状態
@export var is_menu_enable:bool = true

## 押した後にフォーカスを外すかどうか
@export var is_pressed_exit_focus:bool = true

## Hold状態でカーソルを進めるかどうか
@export var hold_enable:bool = true

## 各Commandの連打防止硬直時間
@export var safe_delay_sec:float = 0.2

@export_category("Duration")
@export var duration_steps = 2
@export var key_duration_speed_default = 250
## キーを押してn個目のコマンドでスピードが速くなる
@export var key_speed_sakaime_count_1 = 1
@export var key_duration_speed_1 = 120
@export var key_speed_sakaime_count_2 = 8
@export var key_duration_speed_2 = 60
@export var key_speed_sakaime_count_3 = 24
@export var key_duration_speed_3 = 60

@export_category("Focus")

@export var is_focus_enter_animation:bool = true

@export var is_focus_exit_animation:bool = true

@export var is_focus_save:bool = true

@export var all_item_top_control_path:NodePath

@export var all_item_bottom_control_path:NodePath

@onready var all_item_top_control:Control = get_node_or_null(all_item_top_control_path)

@onready var all_item_bottom_control:Control = get_node_or_null(all_item_bottom_control_path)


@export_category("Debug")
@export var is_debug:bool = false

@export var animation_player_path:NodePath

@onready var animation_player:AnimationPlayer = get_node_or_null(animation_player_path)

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------

## コマンド
var command_list:Array= []

## 空コマンドを含むすべてのコマンド
var all_command_list:Array= []

## 無効時にフォーカス位置をセーブする
var saved_focus_command:Control = null

## 現在フォーカスがあたってるボタン
var focusing_button = null

## ロック状態（入力を無視する）
var is_lock:bool = false


#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
## 最後に押した移動キー　ui_acceptはnullのかわり
var _lastKey:StringName = KEY_UI_ACCEPT

## 現在のキー長押しディレイ
var _key_duration:int = key_duration_speed_default

## キー何個長押しで進んだら速くするかのカウンター
var _key_duration_count:int = 0

## 上移動が有効か
var _is_top_move_enabled = false

## 下移動が有効か
var _is_bottom_move_enabled = false

## ジョイパッドが押されているか
var _is_joy_pressing:bool = false



var joy_pressing:bool = false

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

## 最後にキーを押した時間
@onready var _lastKeyTime:int = Time.get_ticks_msec()

## シーンツリー
@onready var tree:SceneTree = get_tree()

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------
func _ready():
	refresh_commands()
	if !hold_enable:
		key_duration_speed_default = 9999999

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _process(_delta):
	if !is_menu_enable: return
	if is_lock: return
	if Input.is_action_just_pressed(KEY_UI_CANCEL):
		cancel()
	elif (
		(
			_is_joy_pressing
			and
			(
				abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)) < 0.5 \
				and abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) < 0.5\
			)
		)
		or
		(
			# ジョイパッド以外はリリースでとれる
			(
				Input.is_action_just_released(KEY_UI_UP) \
				or Input.is_action_just_released(KEY_UI_DOWN)\
				or Input.is_action_just_released(KEY_UI_LEFT)\
				or Input.is_action_just_released(KEY_UI_RIGHT)\
			)
		)
		):
			_reset_pressing()
	elif (
			(
				IS_JOYPAD_ENABLED 
				and (
					Input.is_action_pressed(KEY_JOY_UP) \
					or Input.is_action_pressed(KEY_JOY_DOWN)\
					or Input.is_action_pressed(KEY_JOY_LEFT)\
					or Input.is_action_pressed(KEY_JOY_RIGHT)\
				)
			)
			or
			(
				(
					Input.is_action_pressed(KEY_UI_UP) \
					or Input.is_action_pressed(KEY_UI_DOWN)\
					or Input.is_action_pressed(KEY_UI_LEFT)\
					or Input.is_action_pressed(KEY_UI_RIGHT)\
				)
			)
		):
		_move_focus_command()
	elif focusing_button != null and Input.is_action_just_pressed(KEY_UI_ACCEPT):
		for command in command_list:
			command.set_focus_exit(false,false)
		
		focusing_button.pressed.emit()
		focusing_button = null

func _on_focus_entered_command(_button):
	focusing_button = _button
	saved_focus_command = focusing_button
	if animation_player != null and animation_player.has_animation("focus_entered"):
		animation_player.play("focus_entered")

func _on_focus_exited_command(_button):
	if animation_player != null and animation_player.has_animation("focus_exited"):
		animation_player.play("focus_exited")

func _on_mouse_entered_command(button):
	for command in command_list:
		if command != button:
			command.set_focus_exit(false,false)
	_on_focus_entered_command(button)
	button.set_focus_enter(true, false)
#	速さリセット
	_key_duration = key_duration_speed_default
	_key_duration_count = 0
	_lastKeyTime = 0 #ウェイトなしにする
	moved_focus.emit(button.position)

func _on_mouse_exited_command(button):
	_on_focus_exited_command(button)


func _on_safe_pressed_command(button):
	safe_pressed.emit(button)
	is_lock = true
	if is_pressed_exit_focus:
		is_lock = true
		for command in command_list:
			if command != button:
				command.set_focus_exit(false,false)
	else:
		button.set_focus_enter()

#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------
func refresh_commands():
	_set_all_item_neighbour_items()

	# set signals
	for command in command_list:
		#SignalStatic.disconnect_target_all(command, self)
		command.safe_delay_sec = safe_delay_sec
		if !command.safe_pressed.is_connected(_on_safe_pressed_command):
			command.safe_pressed.connect(_on_safe_pressed_command.bind(command))
		
		if !command.mouse_entered.is_connected(_on_mouse_entered_command):
			command.mouse_entered.connect(_on_mouse_entered_command.bind(command))
		
		if !command.mouse_exited.is_connected(_on_mouse_exited_command):
			command.mouse_exited.connect(_on_mouse_exited_command.bind(command))

		if is_focus_enter_animation:
			if !command.focus_entered.is_connected(_on_focus_entered_command):
				command.focus_entered.connect(_on_focus_entered_command.bind(command))

		if is_focus_exit_animation:
			if !command.focus_exited.is_connected(_on_focus_exited_command):
				command.focus_exited.connect(_on_focus_exited_command.bind(command))

	if is_menu_enable:
		set_all_items_enable()
	else:
		set_all_items_disable()

## 有効、表示にする
func show_list(unlock_wait_sec:float = 0.0):
	is_menu_enable = true
	visible = true
	set_all_items_enable()
	lock()
	if unlock_wait_sec > 0.01:
		await tree.create_timer(unlock_wait_sec).timeout
	unlock.call_deferred()

## 無効にする
func disable_list():
	is_menu_enable = false
	set_all_items_disable()
	lock()

## 無効、非表示にする
func hide_list():
	disable_list()
	visible = false

## キャンセルする
func cancel():
	is_lock = true
	canceled.emit()
	if animation_player != null and animation_player.has_animation("cancel"):
		animation_player.play("cancel")
		await animation_player.animation_finished
	is_lock = false

func set_command_list(buttons:Array):
	command_list = buttons

func set_all_items_enable()->void:
	var children:Array
	_set_all_item_neighbour_items()
	if command_list.is_empty():
		children = get_all_children(self)
	else:
		children = command_list
	for child  in children:
		if child is Control:
			if child is Button:
				child.disabled = false
				child.safe_disabled = false
				child.focus_mode = Control.FOCUS_ALL
				child.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock()

func set_all_items_disable()->void:
	var children:Array
	if command_list.is_empty():
		children = get_all_children(self)
	else:
		children = command_list
	for child in children:
		if child is Control:
			if child is Button:
				child.disabled = true
				child.safe_disabled = true
				child.focus_mode = Control.FOCUS_NONE
				child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				child.release_focus()
	lock()

func focus_command(command:Control):
	for command_ in command_list:
		command_.set_focus_exit(false,false)
	command.set_focus_enter(false,false)
	focusing_button = command
	saved_focus_command = focusing_button

func focus_by_id(id:StringName):
	for command_ in command_list:
		if command_.id == id:
			command_.set_focus_enter(false,false)
			focusing_button = command_
			saved_focus_command = focusing_button
		else:
			command_.set_focus_exit(false,false)

func focus_first():
	assert(!command_list.is_empty())
	for command in command_list:
		command.set_focus_exit(false,false)
	command_list[0].set_focus_enter(false,false)
	focusing_button = command_list[0]
	saved_focus_command = focusing_button

func focus_saved_command():
	if !saved_focus_command: 
		focus_first()
		return
	for command_ in command_list:
		command_.set_focus_exit(false,false)
	saved_focus_command.set_focus_enter()
	focusing_button = saved_focus_command

func lock():
	is_lock = true

func unlock():
	is_lock = false

#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------


## アイテムすべてのキーフォーカス先を設定する
func _set_all_item_neighbour_items()->void:
	_is_top_move_enabled = false
	_is_bottom_move_enabled = false

	# いれていない子のコマンドを全部セットする
	var prev_command
	var index:int = 0
	var children = get_all_children(self)

	command_list.clear()
	for child in children:
		if child is FoltaUIButton or child is FoltaUIButton:
			if child.is_empty:
				all_command_list.append(child)
				continue
			command_list.append(child)
			child.command_list = self

			if index != 0:
				var pathh = child.get_path_to(prev_command)

				if child.focus_neighbor_left_default == NodePath(""):
					child.focus_neighbor_left = pathh

				if prev_command.focus_neighbor_right_default == NodePath(""):
					prev_command.focus_neighbor_right = prev_command.get_path_to(child)

			if all_item_top_control != null:
				var relative_top_path = child.get_path_to(all_item_top_control)
				child.focus_neighbor_top = relative_top_path
				_is_top_move_enabled = true

			if all_item_bottom_control != null:
				var relative_bottom_path = child.get_path_to(all_item_bottom_control)
				child.focus_neighbor_bottom = relative_bottom_path
				_is_bottom_move_enabled = true

			prev_command = child
			index += 1

	if command_list.is_empty():
		return
	# 一番上から一番下に移動したいのでフォーカスセット
	if command_list[0].focus_neighbor_left_default == NodePath(""):
		command_list[0].focus_neighbor_left = command_list[0].get_path_to(command_list.back())
	if command_list.back().focus_neighbor_right_default == NodePath(""):
		command_list.back().focus_neighbor_right = command_list.back().get_path_to(command_list[0])

	if focusing_button == null and is_menu_enable and !command_list.is_empty():
		focusing_button = command_list[0]
		saved_focus_command = focusing_button
		command_list[0].set_focus_enter(false,false)

func _move_focus_command():
	var is_up:bool = false
	var is_down:bool = false
	var is_left:bool = false
	var is_right:bool = false

	if not IS_JOYPAD_ENABLED:
		is_up = Input.is_action_pressed(KEY_UI_UP)
		is_down = Input.is_action_pressed(KEY_UI_DOWN)
		is_left = Input.is_action_pressed(KEY_UI_LEFT)
		is_right = Input.is_action_pressed(KEY_UI_RIGHT)
	elif Input.is_action_pressed(KEY_JOY_UP):
		is_up = true
		_is_joy_pressing = true
	elif Input.is_action_pressed(KEY_JOY_DOWN):
		is_down = true
		_is_joy_pressing = true
	elif Input.is_action_pressed(KEY_JOY_LEFT):
		is_left = true
		_is_joy_pressing = true
	elif Input.is_action_pressed(KEY_JOY_RIGHT):
		is_right = true
		_is_joy_pressing = true
	else:
		is_up = Input.is_action_pressed(KEY_UI_UP)
		is_down = Input.is_action_pressed(KEY_UI_DOWN)
		is_left = Input.is_action_pressed(KEY_UI_LEFT)
		is_right = Input.is_action_pressed(KEY_UI_RIGHT)

	if (is_up and (is_down or is_left or is_right))\
	or (is_down and (is_up or is_left or is_right))\
	or (is_left and (is_down or is_up or is_right))\
	or (is_right and (is_down or is_left or is_up))\
	:
		# 両押は無効にする
		return

	if !_is_top_move_enabled and is_up:
		return
	if !_is_bottom_move_enabled and is_down:
		return

	if focusing_button == null:
#		focus_first()
		return

	var target_button
	var is_other_key:bool = false
	if is_left and _lastKey != KEY_UI_LEFT:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_left)
		is_other_key = true
	elif is_right and _lastKey != KEY_UI_RIGHT:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_right)
		is_other_key = true
	elif is_up and _lastKey != KEY_UI_UP:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_top)
		is_other_key = true
	elif is_down and _lastKey != KEY_UI_DOWN:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_bottom)
		is_other_key = true
	if Time.get_ticks_msec() - _lastKeyTime > 300:
#		速さリセット
		_key_duration = key_duration_speed_default
		_key_duration_count = 0

#	同じキーかつ前回キー押したTimeと比較して一定秒たっていなければフォーカス処理しない
	if !is_other_key and Time.get_ticks_msec() - _lastKeyTime < _key_duration:
		return

	if is_left:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_left)
		_lastKey = KEY_UI_LEFT
	elif is_right:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_right)
		_lastKey = KEY_UI_RIGHT
	elif is_up:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_top)
		_lastKey = KEY_UI_UP
	elif is_down:
		target_button = focusing_button.get_node(focusing_button.focus_neighbor_bottom)
		_lastKey = KEY_UI_DOWN

#		フォーカスは嘘フォーカスじゃないとだめぽい
	if focusing_button != null:
		focusing_button.set_focus_exit()
	if target_button != null:
		if !command_list.has(target_button):
			is_menu_enable = false
			focusing_button = null
			# 次のコマンドリストにフォーカスを移動する
			target_button.command_list.is_menu_enable = true
			target_button.command_list.focusing_button = target_button
			target_button.command_list._lastKey = _lastKey
			target_button.command_list.is_lock = true
			target_button.set_focus_enter()
			target_button.command_list.set_deferred("is_lock",false)
		else:
			target_button.set_focus_enter()
	focusing_button = target_button
	saved_focus_command = focusing_button
	_lastKeyTime = Time.get_ticks_msec()
	_key_duration_count += 1

	moved_focus.emit(target_button.position)

	if duration_steps >= 3 and _key_duration_count > key_speed_sakaime_count_3:
		_key_duration = key_duration_speed_3
	elif duration_steps >= 2 and _key_duration_count > key_speed_sakaime_count_2:
		_key_duration = key_duration_speed_2
	elif duration_steps >= 1 and _key_duration_count > key_speed_sakaime_count_1:
		_key_duration = key_duration_speed_1

## 長押し状態を解除する
func _reset_pressing():
	# 速さリセット
	_key_duration = key_duration_speed_default
	if !hold_enable:
		_lastKey = &""
		_key_duration = 0
		_lastKeyTime = 0
	_key_duration_count = 0
	_lastKeyTime = 0 #ウェイトなしにする
	_is_joy_pressing = false

static func get_all_children(in_node:Node) -> Array[Node]:
	var children = in_node.get_children()
	var ary:Array[Node] = []
	while not children.is_empty():
		var node = children.pop_back()
		children.append_array(node.get_children())
		ary.append(node)
	ary.reverse()
	return ary
