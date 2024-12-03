extends Node

var api_key : String = "0f3b2112b5a13aa5bf07936886b020e5.PtgpsrNdUubkAxXx"
var url : String = "https://open.bigmodel.cn/api/paas/v4/chat/completions"
var temperature : float = 0.7
var max_tokens : int = 1024
var headers = [
	"Content-type: application/json",
	"Authorization: Bearer " + api_key
]
var model : String = "glm-4"
var messages = []
var request : HTTPRequest

@onready var dialogue_box: Control = $"../DialogueBox"
@export_multiline var dialogue_rules : String

signal on_player_talk
signal on_npc_talk (npc_dialogue)


func _ready():
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)
	# dialogue_request("Explain the Godot engine in 20 words.")


func dialogue_request(player_dialogue):
	var prompt = player_dialogue
	
	if len(messages) == 0:
		prompt = dialogue_rules + player_dialogue + "explain player about water quality and quantity situation in relation with cards rather then giving straight answer and answer in 100 words."
	
	messages.append({
		"role": "user",
		"content": prompt
	})
	
	on_player_talk.emit()
	
	var body = JSON.stringify({
		"messages": messages, 
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if send_request != OK:
		print("Error sending request")



func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	var response = json.get_data()
	
	if "choices" in response and response["choices"].size() > 0:
		var message = response["choices"][0]["message"]["content"]
	
		messages.append({
			"role": "system",
			"content": message
		})
	
		on_npc_talk.emit(message)
	else:
		print("Error: Unexpected response format")
