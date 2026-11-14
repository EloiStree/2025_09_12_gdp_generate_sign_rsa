
class_name GodotRsaEmitDecodedTextFromBase58
extends Node


signal on_text_decoded_from_base_58(decoded_text: String)

func decode_text_from_base_58_format(encoded_text: String) -> void:
	var decoded_text: String = GodotRsaBase58Utility.decode_from_utf8_as_base_58(encoded_text)
	on_text_decoded_from_base_58.emit(decoded_text)
