extends Control

@onready var npc_manager: Node = $"../NPCManager"

@onready var player_message_template: RichTextLabel = $ScrollContainer/ChatHistory/PlayerMarginContainer/PlayerMessageTemplate
@onready var npc_message_template: RichTextLabel = $ScrollContainer/ChatHistory/NPCMarginContainer/NPCMessageTemplate

@onready var question_input: TextEdit = $ChatInputArea/QuestionInput
@onready var chat_button: Button = $ChatInputArea/ChatButton

@onready var player_template = preload("res://Scenes/player_margin_container.tscn")
@onready var npc_template = preload("res://Scenes/npc_margin_container.tscn")

@onready var chat_history: VBoxContainer = $ScrollContainer/ChatHistory
@onready var scroll_container: ScrollContainer = $ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	npc_manager.on_player_talk.connect(_on_player_talk)
	npc_manager.on_npc_talk.connect(_on_npc_talk)
	chat_button.connect("pressed", Callable(self, "_on_chat_button_pressed"))
	# question_input.placeholder_text = "How can I help you, ask anthing about the game!?"
	
	# Debug the preloaded paths
	if player_template is PackedScene:
		print("Player template loaded successfully.")
	else:
		print("Error: Player template is not a PackedScene. Check the preload path.")

	if npc_template is PackedScene:
		print("NPC template loaded successfully.")
	else:
		print("Error: NPC template is not a PackedScene. Check the preload path.")



func _on_chat_button_pressed() -> void:
	if question_input.text.strip_edges() != "":
		npc_manager.dialogue_request(question_input.text)
		_add_player_message(question_input.text)
		question_input.clear()


func _on_player_talk():
	chat_button.disabled = true


func _on_npc_talk(npc_dialogue):
	_add_npc_message(npc_dialogue)
	chat_button.disabled = false


func _add_player_message(message: String):
	var player_container = player_template.instantiate()  # Correct for Godot 4.x
	player_container.visible = true  # Ensure it's visible after instancing
	var player_message = player_container.get_node("PlayerMessageTemplate")
	if player_message:
		player_message.text = message
		print("Player message text set successfully.")
	else:
		print("Error: Could not find PlayerMessageTemplate in player container.")
	chat_history.add_child(player_container)



func _add_npc_message(message: String):
	var npc_container = npc_template.instantiate()  # Correct for Godot 4.x
	npc_container.visible = true  # Ensure it's visible after instancing
	var npc_message = npc_container.get_node("NPCMessageTemplate")
	if npc_message:
		npc_message.text = message
		print("NPC message text set successfully.")
	else:
		print("Error: Could not find NPCMessageTemplate in NPC container.")
	chat_history.add_child(npc_container)
