# https://docs.godotengine.org/en/4.4/classes/class_crypto.html#
extends Node

func _ready():
	var crypto = Crypto.new()

	# Generate new RSA key.
	var key = crypto.generate_rsa(4096)

	# Generate new self-signed certificate with the given key.
	var cert = crypto.generate_self_signed_certificate(key, "CN=mydomain.com,O=My Game Company,C=IT")

	# Save key and certificate in the user folder.
	key.save("user://generated.key")
	cert.save("user://generated.crt")

	# Encryption
	var data = "Some data"
	var encrypted = crypto.encrypt(key, data.to_utf8_buffer())

	# Decryption
	var decrypted = crypto.decrypt(key, encrypted)

	# Signing
	var signature = crypto.sign(HashingContext.HASH_SHA256, data.sha256_buffer(), key)

	# Verifying
	var verified = crypto.verify(HashingContext.HASH_SHA256, data.sha256_buffer(), signature, key)

	# Checks
	assert(verified)
	assert(data.to_utf8_buffer() == decrypted)
