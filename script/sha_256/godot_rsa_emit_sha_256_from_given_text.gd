class_name GodotRsaEmitSha256FromGivenText
extends Node

signal on_text_received_to_be_parsed(text_to_parse:String)
signal on_text_parsed_to_sha_256(sha256:String)
signal on_text_parsed_to_sha_256_with_source(source_text:String, sha256:String)

@export var _last_received_text:String
@export var _last_parsed_text_to_sha_256:String

func push_in_text_to_parse_to_sha_256(text:String):
	_last_received_text = text
	var sha256 = GodotRsaSha256Utility.parse_text_to_sha_256_in_text_format(text)
	_last_parsed_text_to_sha_256 = sha256
	on_text_received_to_be_parsed.emit(text)
	on_text_parsed_to_sha_256.emit(sha256)
	on_text_parsed_to_sha_256_with_source.emit(text, sha256)
