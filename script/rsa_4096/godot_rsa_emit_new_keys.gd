class_name GodotRsaEmitNewKeysInRsa4096Format
extends Node

signal on_private_key_generated(key:String)
signal on_public_key_generated(key:String)
signal on_keys_generated(private_key:String, public_key:String)

@export var _last_private_key:String=""
@export var _last_public_key:String=""

func generate_and_emit_new_keys():
	var private:String = GodotRsaCreateSignUtility.create_private_key_rsa_4096()
	var public:String = GodotRsaCreateSignUtility.get_public_key_from_private_key(private)
	
	_last_private_key = private
	_last_public_key = public
	
	on_private_key_generated.emit(private)
	on_public_key_generated.emit(public)
	on_keys_generated.emit(private,public)
	
