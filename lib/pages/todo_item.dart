import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/todo_model.dart';
import '../redux/app_state.dart';
import '../redux/todo_list/todo_list_action.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: StoreConnector<AppState, _ToggleViewModel>(
        distinct: true,
        converter: (Store<AppState> store) => _ToggleViewModel.fromStore(store),
        builder: (BuildContext context, _ToggleViewModel vm) {
          return Checkbox(
            value: todo.completed,
            onChanged: (bool? checked) {
              vm.toggleTodo(todo.id);
            },
          );
        },
      ),
      title: Text(todo.todoDesc),
    );
  }
}

class _ToggleViewModel extends Equatable {
  final void Function(String id) toggleTodo;
  const _ToggleViewModel({
    required this.toggleTodo,
  });

  @override
  List<Object> get props => [];

  static fromStore(Store<AppState> store) {
    return _ToggleViewModel(
      toggleTodo: (String id) => store.dispatch(
        ToggleTodoAction(id: id),
      ),
    );
  }
}
