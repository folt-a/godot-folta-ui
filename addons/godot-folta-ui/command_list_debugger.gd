#01. @tool

#02. class_name

#03. extends
extends Window
#04. # docstring

## デバッグ用ウィンドウシーンです
## ゲーム内に存在している全てのコマンドリストの状態を監視します。

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

const ENABLED_COLUMN_INDEX:int = 1
const LOCK_COLUMN_INDEX:int = 2

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
var _command_lists:Array

var _root_item:TreeItem

#-----------------------------------------------------------
#11. onready variables
#-----------------------------------------------------------
@onready var tree:SceneTree = get_tree()
@onready var list_tree:Tree = %ListTree

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
	list_tree.set_column_title(0,"ノード名")
	list_tree.set_column_title(1,"有効")
	list_tree.set_column_title(2,"ロック中")
	list_tree.set_column_title(3,"選択中ノード名")
	list_tree.set_column_title(4,"選択中ID")
	list_tree.cell_selected.connect(_on_cell_selected)
	refresh()

func refresh():
	tree = get_tree()
	
	_command_lists = []
	list_tree.clear()
	_root_item = list_tree.create_item()
	
	var nodes := get_all_children(tree.root)
	var index:int = 0
	for n in nodes:
		if _is_command_list(n):
			_command_lists.append(n)
			_add_list(n)
			index+=1
	
	tree.node_added.connect(_on_node_added)

func _process(delta: float) -> void:
	update()

func update() -> void:
	if !_root_item: return
	var index:int = 0
	for cmd in _command_lists:
		var item:TreeItem = _root_item.get_child(index)
		item.set_text(0,_command_lists[index].name)
		item.set_checked(1,_command_lists[index].is_menu_enable)
		item.set_checked(2,_command_lists[index].is_lock)
		item.set_text(3, _get_focusing_btn_name(_command_lists[index]))
		item.set_text(4, _get_focusing_btn_id(_command_lists[index]))
		index+=1

#endregion
#-----------------------------------------------------------

#region _virtual Function
#-----------------------------------------------------------
#14. remaining built-in virtual methods
#-----------------------------------------------------------
func _on_node_added(n:Node):
	if _is_command_list(n) and !_command_lists.find(n):
		_command_lists.append(n)
		_add_list(n)


func _is_command_list(n:Node) -> bool:
	return n is FoltaUICommandVList
	#TODO


func _add_list(n:Node):
	var item:= list_tree.create_item(_root_item)
	item.set_text(0,n.name)
	item.set_tooltip_text(0,str(n.get_path()))
	item.set_cell_mode(ENABLED_COLUMN_INDEX,TreeItem.CELL_MODE_CHECK)
	item.set_checked(ENABLED_COLUMN_INDEX,n.is_menu_enable)
	item.set_cell_mode(LOCK_COLUMN_INDEX,TreeItem.CELL_MODE_CHECK)
	item.set_checked(LOCK_COLUMN_INDEX,n.is_lock)
	item.set_text(3, _get_focusing_btn_name(n))
	item.set_text(4, _get_focusing_btn_id(n))


func _get_focusing_btn_id(cmd:Node) -> String:
	if cmd.focusing_button:
		return str(cmd.focusing_button.id)
	return ""


func _get_focusing_btn_name(cmd:Node) -> String:
	if cmd.focusing_button:
		return str(cmd.focusing_button.name)
	return ""


func _get_item_index(item:TreeItem) ->int:
	var index:int = 0
	for _item in _root_item.get_children():
		if item == _item:
			return index
		index += 1
	return -1


func _on_cell_selected():
	var item:TreeItem = list_tree.get_selected()
	var column:int = list_tree.get_selected_column()
	if column == ENABLED_COLUMN_INDEX or column == LOCK_COLUMN_INDEX:
		_on_check(item, column)


func _on_check(item: TreeItem, column: int):
	var checked:bool = item.is_checked(column)
	item.set_checked(column, true)
	var index:int = item.get_index()
	if column == ENABLED_COLUMN_INDEX:
		if !checked:
			_command_lists[index].show_list()
		else:
			_command_lists[index].disable_list()
	elif column == LOCK_COLUMN_INDEX:
		_command_lists[index].is_lock = !checked


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
static func get_all_children(in_node:Node) -> Array[Node]:
	var children = in_node.get_children()
	var ary:Array[Node] = []
	while not children.is_empty():
		var node = children.pop_back()
		children.append_array(node.get_children())
		ary.append(node)
	ary.reverse()
	return ary


#endregion
#-----------------------------------------------------------

