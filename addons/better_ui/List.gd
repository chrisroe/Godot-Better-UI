extends Control
class_name List

var container
var data
@export_enum("vertical", "horizontal", "grid") var listType = "vertical"
@export var gridColumns = 2


func _ready():
	_create_data()
	_create_container()
	_render()
	data.connect("child_entered_tree", _rerender)
	data.connect("child_exiting_tree", _rerender)
	data.connect("child_order_changed", _render)
	
func _create_data():
	var node = Node.new()
	node.name = "Data"
	for n in get_children():
		remove_child(n)
		node.add_child(n)
	add_child(node, true)
	data = node

func _create_container():
	var box
	match listType:
		"horizontal":
			box = HBoxContainer.new()
		"grid":
			box = GridContainer.new()
			box.columns = gridColumns
		"vertical":
			box = VBoxContainer.new()
		_:
			box = VBoxContainer.new()
	
	box.name = "Container"
	add_child(box, true)
	container = box

func _rerender(_changedNode):
	_render()

func _render():
	if container:
		for c in container.get_children():
			c.queue_free()
	for item in data.get_children():
		var i = _render_item(item)
		container.add_child(i)
		
func _render_item(item):
	var l = Label.new()
	l.text = item.name
	return l
