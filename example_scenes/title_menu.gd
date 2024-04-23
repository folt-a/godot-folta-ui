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



#-----------------------------------------------------------
#09. public variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#10. private variables
#-----------------------------------------------------------



#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------

@onready var icon_button: FoltaUIButton = $FoltaUICommandVList/IconButton
@onready var folta_ui_command_v_list: FoltaUICommandVList = $FoltaUICommandVList
@onready var folta_ui_command_v_list_2: FoltaUICommandVList = $FoltaUICommandVList2

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
	#icon_button.is_empty = true
	folta_ui_command_v_list.safe_pressed.connect(_on_list1_pressed)
	folta_ui_command_v_list_2.safe_pressed.connect(_on_list2_pressed)
	folta_ui_command_v_list_2.canceled.connect(_on_list2_canceled)

#endregion
#-----------------------------------------------------------

#region _virtual Function
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------

func _on_list1_pressed(id:StringName, control:Control) -> void:
	folta_ui_command_v_list.disable_list()
	folta_ui_command_v_list_2.show_list()
	folta_ui_command_v_list_2.focus_first()

func _on_list2_pressed(id:StringName, control:Control) -> void:
	
	pass

func _on_list2_canceled():
	folta_ui_command_v_list_2.disable_list()
	folta_ui_command_v_list.show_list()
	folta_ui_command_v_list.focus_first()
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



#endregion
#-----------------------------------------------------------

