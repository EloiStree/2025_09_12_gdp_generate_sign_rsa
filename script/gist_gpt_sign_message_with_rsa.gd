extends Node

func _ready():
	# Step 1: Generate a random example text message
	var message = "This is a random example message to sign: Hello, Godot world! " + str(randi())  # Adds randomness
	print("Original message: ", message)
	
	# Step 2: Convert message to bytes and hash it with SHA-256
	var msg_bytes: PackedByteArray = message.to_utf8_buffer()
	var hash_context = HashingContext.new()
	hash_context.start(HashingContext.HASH_SHA256)
	hash_context.update(msg_bytes)
	var hash_bytes: PackedByteArray = hash_context.finish()
	print("SHA-256 hash (hex): ", hash_bytes.hex_encode())
	
	# Step 3: Generate an RSA private key (2048 bits for security)
	var crypto = Crypto.new()
	var private_key = crypto.generate_rsa(2048)
	# Export public key only (Godot 4.x: single bool arg, returns String directly)
	var public_key_pem: String = private_key.save_to_string(true)  # true = public_only
	print("Public key (PEM): ", public_key_pem)
	
	# Step 4: Sign the hash using the private key
	var signature_bytes: PackedByteArray = crypto.sign(HashingContext.HASH_SHA256, hash_bytes, private_key)
	var signature_base64: String = Marshalls.raw_to_base64(signature_bytes)
	print("Signature (Base64): ", signature_base64)
	
	# Optional: Verify the signature (using the same key object; works with private or public)
	var is_valid: bool = crypto.verify(HashingContext.HASH_SHA256, hash_bytes, signature_bytes, private_key)
	print("Signature valid? ", is_valid)  # Should print 'true'
