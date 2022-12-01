import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/todo_model.dart';
import '../redux/app_state.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        final todos = vm.todos;

        return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: todos.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            return Text(
              todos[index].todoDesc,
              style: const TextStyle(fontSize: 20.0),
            );
          },
        );
      },
    );
  }
}

class _ViewModel extends Equatable {
  final List<Todo> todos;
  const _ViewModel({
    required this.todos,
  });

  @override
  List<Object> get props => [todos];

  static fromStore(Store<AppState> store) {
    return _ViewModel(
      todos: _getFilteredTodos(
        todos: store.state.todoListState.todos,
        todoFilter: store.state.todoFilterState.todoFilter,
        searchTerm: store.state.todoSearchState.searchTerm,
      ),
    );
  }

  static List<Todo> _getFilteredTodos({
    required List<Todo> todos,
    required TodoFilter todoFilter,
    required String searchTerm,
  }) {
    List<Todo> filteredTodos;

    switch (todoFilter) {
      case TodoFilter.all:
        filteredTodos = todos;
        break;
      case TodoFilter.completed:
        filteredTodos = todos.where((todo) => todo.completed).toList();
        break;
      case TodoFilter.active:
        filteredTodos = todos.where((todo) => !todo.completed).toList();
        break;
      default:
        filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos.where((Todo todo) {
        if (todo.todoDesc.toLowerCase().contains(searchTerm.toLowerCase())) {
          return true;
        }
        return false;
      }).toList();
    }

    return filteredTodos;
  }
}
