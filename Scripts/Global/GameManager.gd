extends Node
class_name GameManagerScript

enum state {INTRO, SELECTION, RESULT, POST_RESULT}
var current_state: state = state.SELECTION

var PRODUCTS_SELECT_LIMIT: int = 5
