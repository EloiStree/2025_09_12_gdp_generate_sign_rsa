
class_name GodotRsaBase58Utility
extends Node

const ALPHABET: String = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"


static func encode_bytes_to_string_base_58(input: PackedByteArray) -> String:
	if input.is_empty():
		return ""

	# Count leading zeroes.
	var zero_count: int = 0
	while zero_count < input.size() and input[zero_count] == 0:
		zero_count += 1

	# Work on a copy of the input.
	var number: PackedByteArray = input.duplicate()

	# Maximum possible Base58 output size.
	var temp: PackedByteArray = PackedByteArray()
	temp.resize(input.size() * 2)

	var j: int = temp.size()
	var start_at: int = zero_count

	# Convert base 256 to base 58.
	while start_at < number.size():
		var mod: int = _div_mod_58(number, start_at)

		if number[start_at] == 0:
			start_at += 1

		j -= 1
		temp[j] = ALPHABET.unicode_at(mod)

	# Remove extra leading '1' characters.
	while j < temp.size() and temp[j] == ALPHABET.unicode_at(0):
		j += 1

	# Restore leading zeroes as Base58 '1' characters.
	while zero_count > 0:
		zero_count -= 1
		j -= 1
		temp[j] = ALPHABET.unicode_at(0)

	var output: PackedByteArray = temp.slice(j, temp.size())
	return output.get_string_from_ascii()


static func decode_string_base_58_to_bytes(input: String) -> PackedByteArray:
	if input.is_empty():
		return PackedByteArray()

	var input58: PackedByteArray = PackedByteArray()
	input58.resize(input.length())

	# Convert Base58 characters to their numeric values.
	for i in range(input.length()):
		var char_code: int = input.unicode_at(i)
		var digit: int = ALPHABET.find(char(char_code))

		if digit < 0:
			push_error("Illegal Base58 character '%s' at position %d" % [char(char_code), i])
			return PackedByteArray()

		input58[i] = digit

	# Count leading zeroes.
	var zero_count: int = 0
	while zero_count < input58.size() and input58[zero_count] == 0:
		zero_count += 1

	# Convert base 58 to base 256.
	var temp: PackedByteArray = PackedByteArray()
	temp.resize(input.length())

	var j: int = temp.size()
	var start_at: int = zero_count

	while start_at < input58.size():
		var mod: int = _div_mod_256(input58, start_at)

		if input58[start_at] == 0:
			start_at += 1

		j -= 1
		temp[j] = mod

	# Remove extra leading zeroes.
	while j < temp.size() and temp[j] == 0:
		j += 1

	# Restore original leading zeroes.
	return temp.slice(j - zero_count, temp.size())



static func encode_to_utf8_as_base_58(input: String) -> String:
	return encode_bytes_to_string_base_58(input.to_utf8_buffer())

static func decode_from_utf8_as_base_58(input: String) -> String:
	var data: PackedByteArray = decode_string_base_58_to_bytes(input)
	return data.get_string_from_utf8()


static func _div_mod_58(number: PackedByteArray, start_at: int) -> int:
	var remainder: int = 0

	for i in range(start_at, number.size()):
		var temp: int = remainder * 256 + number[i]

		number[i] = temp / 58
		remainder = temp % 58

	return remainder


static func _div_mod_256(number58: PackedByteArray, start_at: int) -> int:
	var remainder: int = 0

	for i in range(start_at, number58.size()):
		var temp: int = remainder * 58 + number58[i]

		number58[i] = temp / 256
		remainder = temp % 256

	return remainder
 


#using System;
#using System.Collections.Generic;
#using System.Text;
#
	#public class TBIO_Base58
#{
		#public static readonly char[] _alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz".ToCharArray();
		#private static int[] _indexes = new int[128];
#
		#static TBIO_Base58()
		#{
			#for (int i = 0; i < _indexes.Length; i++)
			#{
				#_indexes[i] = -1;
			#}
			#for (int i = 0; i < _alphabet.Length; i++)
			#{
				#_indexes[_alphabet[i]] = i;
			#}
		#}
		#static void Main(string[] args)
		#{
			#if (0 == args.Length)
			#{
				#PrintHelpInformation();
				#return;
			#}
			#if (1 == args.Length)
			#{
				#Console.WriteLine("Invalid parameters input. Please view help information.");
				#PrintHelpInformation();
				#return;
			#}
			#if (2 == args.Length)
			#{
				#if ("-d" == args[0].ToLower() || "--decode" == args[0].ToLower())
				#{
					#byte[] result = Base58Decode(args[1]);
					#string hex = BitConverter.ToString(result);
					#if (!String.IsNullOrEmpty(hex))
					#{
						#Console.WriteLine("Decoded result:");
						#Console.WriteLine(hex);
					#}
					#else
					#{
						#Console.WriteLine("Invalid crypto address.");
					#}
				#}
				#else if ("-e" == args[0].ToLower() || "--encode" == args[0].ToLower())
				#{
					#// byte[] data = BitConverter.GetBytes(args[1].Trim().Replace("-", ""));
					#string[] temp = args[1].Split("-");
					#List<byte> data = new List<byte>();
					#foreach (string s in temp)
					#{
						#data.Add(Convert.ToByte(Convert.ToInt32(s, 16)));
					#}
					#Console.WriteLine(Base58Encode(data.ToArray()));
				#}
				#else
				#{
					#Console.WriteLine("Invalid parameter");
					#PrintHelpInformation();
				#}
			#}
		#}
#
	#public static string Base58Encode(byte[] input)
		#{
			#if (0 == input.Length)
			#{
				#return String.Empty;
			#}
			#input = CopyOfRange(input, 0, input.Length);
			#// Count leading zeroes.
			#int zeroCount = 0;
			#while (zeroCount < input.Length && input[zeroCount] == 0)
			#{
				#zeroCount++;
			#}
			#// The actual encoding.
			#byte[] temp = new byte[input.Length * 2];
			#int j = temp.Length;
#
			#int startAt = zeroCount;
			#while (startAt < input.Length)
			#{
				#byte mod = DivMod58(input, startAt);
				#if (input[startAt] == 0)
				#{
					#startAt++;
				#}
				#temp[--j] = (byte)_alphabet[mod];
			#}
#
			#// Strip extra '1' if there are some after decoding.
			#while (j < temp.Length && temp[j] == _alphabet[0])
			#{
				#++j;
			#}
			#// Add as many leading '1' as there were leading zeros.
			#while (--zeroCount >= 0)
			#{
				#temp[--j] = (byte)_alphabet[0];
			#}
#
			#byte[] output = CopyOfRange(temp, j, temp.Length);
			#try
			#{
				#return Encoding.ASCII.GetString(output);
			#}
			#catch (DecoderFallbackException e)
			#{
				#Console.WriteLine(e.ToString());
				#return String.Empty;
			#}
		#}
		#public static byte[] Base58Decode(string input)
		#{
			#if (0 == input.Length)
			#{
				#return new byte[0];
			#}
			#byte[] input58 = new byte[input.Length];
			#// Transform the String to a base58 byte sequence
			#for (int i = 0; i < input.Length; i++)
			#{
				#char c = input[i];
#
				#int digit58 = -1;
				#if (c >= 0 && c < 128)
				#{
					#digit58 = _indexes[c];
				#}
				#if (digit58 < 0)
				#{
					#throw new ArgumentException("Illegal character " + c + " at " + i);
				#}
#
				#input58[i] = (byte)digit58;
			#}
			#// Count leading zeroes
			#int zeroCount = 0;
			#while (zeroCount < input58.Length && input58[zeroCount] == 0)
			#{
				#zeroCount++;
			#}
			#// The encoding
			#byte[] temp = new byte[input.Length];
			#int j = temp.Length;
#
			#int startAt = zeroCount;
			#while (startAt < input58.Length)
			#{
				#byte mod = DivMod256(input58, startAt);
				#if (input58[startAt] == 0)
				#{
					#++startAt;
				#}
				#temp[--j] = mod;
			#}
			#// Do no add extra leading zeroes, move j to first non null byte.
			#while (j < temp.Length && temp[j] == 0)
			#{
				#j++;
			#}
			#return CopyOfRange(temp, j - zeroCount, temp.Length);
		#}
		#static void PrintHelpInformation()
		#{
			#Console.WriteLine("Base58 is a commad line tool for encode/decode cryptocurrency address.");
			#Console.WriteLine("Copyright: micl refernced Apache Base58 encode/decode and created Feb/2018.");
			#Console.WriteLine("-e/--encode means encode a big int to Base58 string. Oppositely, -d/--decode can retrieve big int value from Base58 string.");
			#Console.WriteLine("Below are command line samples......");
			#Console.WriteLine("Decoding Base58 address:");
			#Console.WriteLine("dotnet base58.dll --decode \"13ShSwCSKV5W7MpCgt9jYPQ9TovfkqtNZ2\"");
			#Console.WriteLine("dotnet run -e 17-5A-CD-AD-31-B0-22-30-D8-D3-E2-88-3A-D3-A0-B3-BF-AD-98-B1-2C-8D-B6-80-7B");
		#}
#
		#static byte DivMod58(byte[] number, int startAt)
		#{
			#int remainder = 0;
			#for (int i = startAt; i < number.Length; i++)
			#{
				#int digit256 = (int)number[i] & 0xFF;
				#int temp = remainder * 256 + digit256;
#
				#number[i] = (byte)(temp / 58);
#
				#remainder = temp % 58;
			#}
#
			#return (byte)remainder;
		#}
		#static byte DivMod256(byte[] number58, int startAt)
		#{
			#int remainder = 0;
			#for (int i = startAt; i < number58.Length; i++)
			#{
				#int digit58 = (int)number58[i] & 0xFF;
				#int temp = remainder * 58 + digit58;
#
				#number58[i] = (byte)(temp / 256);
#
				#remainder = temp % 256;
			#}
#
			#return (byte)remainder;
		#}
		#static byte[] CopyOfRange(byte[] source, int from, int to)
		#{
			#byte[] range = new byte[to - from];
			#for (int i = 0; i < to - from; i++)
			#{
				#range[i] = source[from + i];
			#}
			#return range;
		#}
#
	#public static string Base58EncodeToUTF8(string str)
	#{
		#return Base58Encode(Encoding.UTF8.GetBytes(str));
	#}
#
	#public static string Base58DecodeFromUTF8(string b58)
	#{
#
		#byte[] data = Base58Decode(b58);
		#return Encoding.UTF8.GetString(data);
	#}
#}
#
#
#
#
#
