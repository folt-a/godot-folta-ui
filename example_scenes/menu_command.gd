#01. @tool
@tool
#02. class_name

#03. extends
extends FoltaUIButton
#04. # docstring

## アイコン・テキスト・ボタンアニメーションのサンプルです。
## このスクリプトのようにFoltaUIButtonやFoltaUIImageButtonなどをextendして
## 主に見た目などの処理を好きに追加します。

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

@export_multiline var menu_text:String = "":
	set(v):
		menu_text = v
		if label:
			label.text = v
			if menu_text != "":
				label.visible = true

@export var menu_icon:Texture2D:
	set(v):
		menu_icon = v
		if icon_margin_container:
			if menu_icon:
				icon_margin_container.visible = true
				icon_texture_rect.visible = true
				icon_texture_rect.texture = v
			else:
				icon_margin_container.visible = false
				icon_texture_rect.visible = false

@export var label_settings:LabelSettings = null:
	set(v):
		label_settings = v
		if label:
			label.label_settings = v

## フォーカスしたときの音
@export var focus_sound:StringName = &"cursor_move_0"

## 押した時の音
@export var press_sound:StringName = &"accept"



#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------
func resize() -> void:
	self.custom_minimum_size = margin_container.size
	pivot_offset = margin_container.size / 2
	if center_position:
		center_position.position = margin_container.size / 2


#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

@onready var margin_container: MarginContainer = %MarginContainer
@onready var icon_margin_container: MarginContainer = %IconMarginContainer
@onready var icon_texture_rect: TextureRect = %IconTextureRect
@onready var label: Label = %Label



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
	to_empty.connect(_empty_toggle)
	menu_icon = menu_icon
	menu_text = menu_text
	label_settings = label_settings
	resize.call_deferred()
	if is_empty:
		_empty_toggle(is_empty)



#endregion
#-----------------------------------------------------------

#region _virtual Function
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _pressed():
	pass


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

func _play_sound(audio_name:StringName):
	# your
	#
	#AudioSystem.play_sound(press_sound)
	pass

func _empty_toggle(is_empty:bool):
	margin_container.visible = !is_empty
	print("hide")


#endregion
#-----------------------------------------------------------

