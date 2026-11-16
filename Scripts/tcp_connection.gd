extends Node

var peer_tcp := StreamPeerTCP.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var error = peer_tcp.connect_to_host("127.0.0.1",5000)
	if error != OK:
		print("Conexão falhou !")
	else:
		print("Conexão aberta !")
	
	var packed_message = "DFHack?\n".to_ascii_buffer()
	var versão := PackedInt32Array([1]).to_byte_array()
	print(versão)
	print(packed_message.hex_encode())
	var enviar = packed_message + versão
	print(enviar)
	
	peer_tcp.poll()
	error = peer_tcp.put_data(enviar)
	if error != OK:
		print("Erro no envio: ", error)
	else:
		print("Mensagem eviada com sucesso !")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	peer_tcp.poll()
	var tamanho_resposta = peer_tcp.get_available_bytes()
	if tamanho_resposta > 0: 
		print("Tamanho da resposta: ", tamanho_resposta)
		var resposta = peer_tcp.get_data(tamanho_resposta)
		print("Resposta: ",resposta)
		print(resposta[1].get_string_from_ascii())
