@tool
extends EditorPlugin

var dock

var ei = get_editor_interface()

func _enable_plugin():
	# FIXME: How to cancel enabling this plugin
	#        when `gd-openai` is not available or enabled?
	if not ei.is_plugin_enabled('gd-openai'):
		print("No gd-openai plugin found. Please enable.")

func _enter_tree():
	dock = preload("res://addons/gd-openai-coding/dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock)

	dock.find_child("Reload").connect("pressed", self.reload)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.queue_free()


func _disable_plugin():
	pass

func reload():
	print(" Reloading GD OpenAI coding.")
	_exit_tree()
	_enter_tree()
