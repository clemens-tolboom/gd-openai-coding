@tool
class_name GdOpenAiExplain

extends VBoxContainer

## Explaining code needs different settings.
##
## FIXME: should we use text-davinci-003 instead
## FIXME: this should be CompletionRequest on /v1/completions
@export var request:ChatCompletionRequest

@export var text_in:String = "":
	set(v):
		print("setting")
		if is_node_ready():
			$SelectedCode.text = v
		else:
			print_debug("Cannot set value yet for explain input")

func _ready():
	print($SelectedCode.text)
