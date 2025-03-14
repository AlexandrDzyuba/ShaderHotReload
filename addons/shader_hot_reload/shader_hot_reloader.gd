@tool

extends Node

var T = 0;

const update_rate = 0.5;

const path : String = "user://_hot_reload.txt";

## Checks for updates
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		T += delta;
		if T > update_rate:
			T = 0;
			
			if FileAccess.file_exists(path):
				var hr = load_dictionary(path);
				
				for resource_path in hr.list:
					var resource = load(resource_path);
					if resource is ShaderMaterial && resource.shader != null:
						var shader = ResourceLoader.load(resource.shader.resource_path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP);
						resource.shader = shader;
						print("Hot reload for :", resource.shader.resource_path);
				
				DirAccess.remove_absolute(path);

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
