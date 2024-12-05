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
var area_stats = {
	"Area1": preload("res://Scenes/enemy_area_1.gd").new(),
	"Area2": preload("res://Scenes/enemy_area_2.gd").new(),
	"Area3": preload("res://Scenes/enemy_area_3.gd").new(),
	"Area4": preload("res://Scenes/enemy_area_4.gd").new(),
	"Area5": preload("res://Scenes/enemy_area_5.gd").new(),
}



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
	# Always update the stats summary
	var stats_summary = ""
	var group_prefix = "area"
	
	for i in range(1, 6):  # Looping through all areas
		var group_name = "%s%d" % [group_prefix, i]
		var area_nodes = get_tree().get_nodes_in_group(group_name)
		
		# Assuming one node per group contains the stats
		if area_nodes.size() > 0:
			var area = area_nodes[0]
			if area.has_node("EnemyStatsUI"):
				var stats_ui = area.get_node("EnemyStatsUI") as EnemyStatsUI
				if stats_ui:
					stats_summary += "%s - Quality: %d, Quantity: %d, Popularity: %d\n" % [
						group_name,
						stats_ui.quality.value,
						stats_ui.quantity.value,
						stats_ui.popularity.value
					]
	
	# Add the stats summary to the dialogue prompt
	var prompt = "%s\n\n%s\n%s" % [dialogue_rules, stats_summary, player_dialogue] + "You can only react with emotion in 20 words. If you feel your reaction is not enough to guide the player, you can not react but answer player's question in 40 words."
	
	# Append the message if it's not already present
	messages.append({
		"role": "user",
		"content": prompt
	})
	
	print(stats_summary)  # Print updated stats summary to verify

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
