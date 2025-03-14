@tool
extends EditorPlugin

var inspector_plugin = load("res://addons/shader_hot_reload/inspector_plugin.gd").new();

func _enter_tree() -> void:
	add_inspector_plugin(inspector_plugin);
	add_autoload_singleton("ShaderHotReloader", "res://addons/shader_hot_reload/shader_hot_reloader.gd")

func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin);
	remove_autoload_singleton("ShaderHotReloader");
