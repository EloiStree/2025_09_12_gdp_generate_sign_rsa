class_name GodotRsaCreateSignUtility
extends Node



static func create_private_key_rsa_4096()->String:
	var crypto = Crypto.new()
	var key = crypto.generate_rsa(4096)
	return key.save_to_string() 

static func get_public_key_from_private_key(private_key_string:String)->String:
	var key = CryptoKey.new()
	key.load_from_string(private_key_string)
	return key.save_to_string(true)

static func create_sign_rsa_4096(private_key_string:String, text_to_sign:String)->String:
	var crypto = Crypto.new()
	var key = crypto.load_rsa(private_key_string)
	var signature = crypto.sign(HashingContext.HASH_SHA256, text_to_sign.to_utf8_buffer(), key)
	return signature.hex_encode()

static func verify_sign_rsa_4096(public_key_string:String, text_to_verify:String, signature_hex:String)->bool:
	var crypto = Crypto.new()
	var key = crypto.load_rsa(public_key_string)
	var signature = PackedByteArray()
	signature.parse_hex(signature_hex)
	return crypto.verify(HashingContext.HASH_SHA256, text_to_verify.to_utf8_buffer(), signature, key)











## https://docs.godotengine.org/en/4.4/classes/class_crypto.html#
#extends Node
#
#func _ready():
#	var crypto = Crypto.new()
#
#	# Generate new RSA key.
#	var key = crypto.generate_rsa(4096)
#
#	# Generate new self-signed certificate with the given key.
#	var cert = crypto.generate_self_signed_certificate(key, "CN=mydomain.com,O=My Game Company,C=IT")
#
#	# Save key and certificate in the user folder.
#	key.save("user://generated.key")
#	cert.save("user://generated.crt")
#
#	# Encryption
#	var data = "Some data"
#	var encrypted = crypto.encrypt(key, data.to_utf8_buffer())
#
#	# Decryption
#	var decrypted = crypto.decrypt(key, encrypted)
#
#	# Signing
#	var signature = crypto.sign(HashingContext.HASH_SHA256, data.sha256_buffer(), key)
#
#	# Verifying
#	var verified = crypto.verify(HashingContext.HASH_SHA256, data.sha256_buffer(), signature, key)
#
#	# Checks
#	assert(verified)
#	assert(data.to_utf8_buffer() == decrypted)
