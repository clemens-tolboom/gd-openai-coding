@tool
extends Control

var system_prompt:String = """
You are a Godot engine 4.x developer using GDScript 2.0.

You task is to write some code based on the user input.

You task is to write some code based on the user input.

All code samples have pattern

```gdscript
code
```
"""

var connector:OpenAiApiRequest = OpenAiApiRequest.new()
var request:ChatCompletionRequest = ChatCompletionRequest.new()
var response:ChatCompletionResponse = ChatCompletionResponse.new()

var input:TextEdit

var question:TextEdit
var answer:TextEdit
var qa_prompt:TextEdit
var main_tabs:TabContainer

func _ready():
	add_child(connector)
	connector.connect("data_received", _on_open_ai_api_request_data_received)
	connector.connect("error_response", _on_open_ai_api_request_error_response)

	question = %Question
	answer = %Answer
	qa_prompt = %QAPrompt
	qa_prompt.text = system_prompt

	main_tabs = %MainTabs

func build_messages():
	print("build_messages >", request.messages.size())
	var sys_msg:ChatCompletionRequestMessage = ChatCompletionRequestMessage.new()
	sys_msg.role = 'system'
	sys_msg.content = system_prompt

	var user_msg:ChatCompletionRequestMessage = ChatCompletionRequestMessage.new()
	user_msg.role = 'user'
	user_msg.content = question.text

	request.messages = [sys_msg, user_msg]
	print("build_messages <", request.messages.size())


func _on_open_ai_api_request_data_received(data):
	response = data
	var t:String = response.choices[0].message.content
	print(t)
	answer.text = t


func _on_open_ai_api_request_error_response(error):
	print(error)


func _on_submit_pressed():
	print("_on_submit_pressed")
	build_messages()
	
	connector.do_post(request, response)


func _on_tab_container_tab_changed(tab):
	var t:String = main_tabs.get_tab_control(tab).name
	if t == 'Explain':
		var code = get_selected_code()
		printt("Explaining", code)
		var x:GdOpenAiExplain = %Explain
		printt(x, '"', x.text_in, '"')
		x.text_in = code
		printt(x, '"', x.text_in, '"')


func get_selected_code():
	var ep: EditorPlugin = EditorPlugin.new()
	if ep == null:
		return "Unable to find Editor context."

	var ei = ep.get_editor_interface()
	if ei == null:
		return "No editor interface found."
	
	var se:ScriptEditor = ei.get_script_editor()
	if se == null:
		return "No script editor found."

	var ce:ScriptEditorBase = se.get_current_editor()
	if ce == null:
		return "No current editor."

	var code_editor:Control = ce.get_base_editor()
	if code_editor == null:
		return "No codefound"
		
	return code_editor.get_selected_text()
