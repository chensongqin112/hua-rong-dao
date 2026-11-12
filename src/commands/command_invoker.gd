class_name CommandInvoker

var _undo_stack: Array[Command] = []
var _redo_stack: Array[Command] = []

func execute(command: Command) -> bool:
	if not command.execute():
		return false
	_undo_stack.append(command)
	_redo_stack.clear()
	return true

func undo() -> Command:
	if _undo_stack.is_empty():
		return null
	var command: Command = _undo_stack.pop_back()
	command.undo()
	_redo_stack.append(command)
	return command

func redo() -> Command:
	if _redo_stack.is_empty():
		return null
	var command: Command = _redo_stack.pop_back()
	command.execute()
	_undo_stack.append(command)
	return command

func undo_count() -> int:
	return _undo_stack.size()
