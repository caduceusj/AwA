extends Node
class_name GameManagerScript

enum state {INTRO, LOAD, SELECTION, RESULT, POST_RESULT}
var current_state: state = state.SELECTION

var PRODUCTS_SELECT_LIMIT: int = 5

var returOptionsScene = "res://Scene/MainMenu/MainMenu.tscn"
var correct_experiments: Array[GenericExperiment]
