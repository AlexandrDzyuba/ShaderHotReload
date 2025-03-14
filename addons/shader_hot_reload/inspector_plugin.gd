@tool

extends EditorInspectorPlugin

const path : String = "user://_hot_reload.txt";

func _can_handle(object) -> bool:
	return object is ShaderMaterial && !object.resource_path.is_empty() && object.shader != null && !object.shader.resource_path.is_empty()

func _parse_begin(object):
	var hot_reload = Button.new()
	hot_reload.size_flags_horizontal = Control.SizeFlags.SIZE_EXPAND_FILL
	hot_reload.text = "Hot reload"
	hot_reload.icon = EditorInterface.get_editor_theme().get_icon("Reload", "EditorIcons")
	
	hot_reload.pressed.connect(on_hot_reload.bind(object))
	add_custom_control(hot_reload)

## Editor method to add resource to sync
func on_hot_reload(object : ShaderMaterial):
	var hr = load_dictionary(path);
	if hr == null:
		hr = {
			list = []
		}
	
	hr.list.append(object.resource_path)
	save_dictionary(hr, path)


## Saving dictionary to file
func save_dictionary(dictionary: Dictionary, fpath: String) -> void:
	var file = FileAccess.open(fpath, FileAccess.WRITE)
	if !FileAccess.get_open_error() == OK:
		print(fpath, ": ERROR saving :",FileAccess.get_open_error())
	file.store_string(var_to_str(dictionary))
	file.close()

## Load dictionary from file
func load_dictionary(fpath: String):
	var file = FileAccess.open(fpath, FileAccess.READ)
	
	if file != null:
		var err = FileAccess.get_open_error()
		var read_dictionary = null 
		if OK != err:
			print(fpath, ": ERROR loading(not match error) ",err)
		if file.is_open():
			read_dictionary = str_to_var(file.get_as_text())
		file.close()
		if (str(read_dictionary).length() <= 1):
			read_dictionary = null
		return read_dictionary
	return null
