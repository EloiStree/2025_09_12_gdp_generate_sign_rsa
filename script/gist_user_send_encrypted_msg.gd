# Source https://github.com/godotengine/godot-docs-user-notes/discussions/364#discussioncomment-13483903\
extends Node

func _ready():
	# Computer A (Server)
	var computer_a = {
		crypto = Crypto.new(),
		private_key = null,
		peer_public_key = null
	}
	# Computer B (Client)
	var computer_b = {
		crypto = Crypto.new(),
		private_key = null,
		peer_public_key = null
	}
	
	var secret_msg = "I like apples"
	
	# Generate RSA key pairs
	computer_a.private_key = computer_a.crypto.generate_rsa(4096)
	computer_b.private_key = computer_b.crypto.generate_rsa(4096)
	
	# Export public keys as strings
	var a_pubkey = computer_a.private_key.save_to_string(true)
	var b_pubkey = computer_b.private_key.save_to_string(true)
	
	# Create CryptoKey objects for peer public keys
	var key_a = CryptoKey.new()
	var key_b = CryptoKey.new()
	
	# Load peer public keys (load_from_string returns error code, modifies the key object)
	key_a.load_from_string(b_pubkey, true)
	key_b.load_from_string(a_pubkey, true)
	
	# Assign the loaded keys
	computer_a.peer_public_key = key_a
	computer_b.peer_public_key = key_b
	
	# Computer A encrypts message with B's public key
	var encrypted = computer_a.crypto.encrypt(computer_a.peer_public_key, secret_msg.to_utf8_buffer())
	print("Encrypted: ", encrypted.hex_encode())
	
	# Computer B decrypts with its own private key
	var decrypted = computer_b.crypto.decrypt(computer_b.private_key, encrypted)
	var decrypted_text = decrypted.get_string_from_utf8()
	print("Decrypted: ", decrypted_text)
