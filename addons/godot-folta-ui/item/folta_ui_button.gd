#-----------------------------------------------------------
#01. tool
#-----------------------------------------------------------
@tool
#-----------------------------------------------------------
#02. class_name
#-----------------------------------------------------------
class_name FoltaUIButton

#-----------------------------------------------------------
#03. extends
#-----------------------------------------------------------
extends Button

#-----------------------------------------------------------
#04. # docstring
## Button
## CommandListのコマンドリストArrayにセットするテキストコマンド。
## アイコンもあるよ
#-----------------------------------------------------------

#-----------------------------------------------------------
#05. signals
#-----------------------------------------------------------
signal safe_pressed
signal safe_focus_entered
signal safe_focus_exited
signal safe_hover_entered
signal safe_hover_exited
signal to_empty(is_empty:bool)

#-----------------------------------------------------------
#06. enums
#-----------------------------------------------------------

#-----------------------------------------------------------
#07. constants
#-----------------------------------------------------------
const FrameTimer = preload("res://addons/godot-folta-ui/frame_timer.gd")
#-----------------------------------------------------------
#08. exported variables
#-----------------------------------------------------------

## 押したボタンを判別する一意のID
@export var id: StringName = &""

## 空状態（選択できない・表示できない状態）
@export var is_empty:bool = false:
	set(v):
		is_empty = v
		to_empty.emit(v)

## ボタン連打を防ぐための硬直秒数
@export var safe_delay_sec:float = 0.1

#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------
var command_list:Control

#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var animation_player:AnimationPlayer = get_node_or_null("%AnimationPlayer")

#@onready var focus_sound:AudioStreamPlayer = get_node_or_null("%FocusSound")
#@onready var press_sound:AudioStreamPlayer = get_node_or_null("%PressSound")
@onready var center_position = get_node_or_null("%CenterPosition")

var particles = null

var safe_disabled:bool = false

var ready_frame_timer := FrameTimer.new()
const ready_timer_wait_frames:int = 1
var click_timer := Timer.new()

var focus_neighbor_top_default:NodePath = NodePath("")
var focus_neighbor_left_default:NodePath = NodePath("")
var focus_neighbor_right_default:NodePath = NodePath("")
var focus_neighbor_bottom_default:NodePath = NodePath("")

#-----------------------------------------------------------
#12. optional built-in virtual _init method
#-----------------------------------------------------------

func _init() -> void:
	focus_mode = FOCUS_NONE

#-----------------------------------------------------------
#13. built-in virtual _ready method
#-----------------------------------------------------------

func _notification(what:int):
	if what == NOTIFICATION_READY:
		focus_mode = Control.FOCUS_NONE
		pressed.connect(_on_pressed)
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
		add_child(click_timer)
		click_timer.one_shot = true
		
		focus_neighbor_top_default = focus_neighbor_top
		focus_neighbor_left_default = focus_neighbor_left
		focus_neighbor_right_default = focus_neighbor_right
		focus_neighbor_bottom_default = focus_neighbor_bottom
		
		safe_disabled = disabled

		if center_position:
			center_position.position = size / 2
			if center_position.has_node("ParticlesWrap"):
				particles = center_position.get_node("ParticlesWrap")

		pivot_offset = size / 2
		
		if ready_timer_wait_frames != 0.0:
			safe_disabled = true
			add_child(ready_frame_timer)
			ready_frame_timer.wait_frames = ready_timer_wait_frames
			ready_frame_timer.one_shot = true
			ready_frame_timer.start()
			await ready_frame_timer.timeout
		safe_disabled = false

#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _on_pressed() -> void:
	if safe_disabled: 
		print("SAFE GUARD:", click_timer.time_left)
		set_focus_enter()
		return
	if disabled:
		set_focus_enter()
		return
	
	if animation_player.has_animation("pressed"):
		animation_player.clear_queue()
		animation_player.play("pressed")
	
	safe_pressed.emit()
	
	safe_disabled = true
	click_timer.start(safe_delay_sec)
	await click_timer.timeout
	safe_disabled = false

func _on_mouse_entered() -> void:
	__hover_enter(true, false)

func _on_mouse_exited() -> void:
	__hover_exit(false)

func _focus_enter() -> void:
	# for override
	pass

func _focus_exit() -> void:
	# for override
	pass

func _hover_enter() -> void:
	# for override
	pass

func _hover_exit() -> void:
	# for override
	pass

func __focus_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	if disabled: return
	focus_mode = Control.FOCUS_ALL
	grab_focus.call_deferred()
	_focus_enter()
	safe_focus_entered.emit()

func __focus_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	if disabled: return
	focus_mode = Control.FOCUS_NONE
	_focus_exit()
	safe_focus_exited.emit()

func __hover_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	if disabled: return
	_hover_enter()
	safe_hover_entered.emit()

func __hover_exit(is_anim:bool = true, _is_audio:bool = true) -> void:
	if disabled: return
	_hover_exit()
	safe_hover_exited.emit()


#-----------------------------------------------------------
#15. public methods
#-----------------------------------------------------------

## 空状態にする
func set_empty_mode(is_empty_:bool) -> void:
	is_empty = is_empty_

## フォーカスする
func set_focus_enter(is_anim:bool = true, is_audio:bool = true) -> void:
	__focus_enter(is_anim,is_audio)

## フォーカスを外す
func set_focus_exit(is_anim:bool = true, is_audio:bool = true) -> void:
	__focus_exit(is_anim,is_audio)


#-----------------------------------------------------------
#16. private methods
#-----------------------------------------------------------
