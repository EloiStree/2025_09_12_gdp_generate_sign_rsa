class_name GodotRsaEmitEncodedTextAsBase58
extends Node


signal on_text_encoded_as_base_58(encoded_text: String)

func encode_text_as_base_58_format(text: String) -> void:
	var encoded_text: String = GodotRsaBase58Utility.encode_to_utf8_as_base_58(text)	
	on_text_encoded_as_base_58.emit(encoded_text)
