import 'package:flutter/material.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Todo List', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _todoItems = [];
  var _filtered;
  final _editController = TextEditingController();
  final _searchController = TextEditingController();
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = Text('AppBar');
  String filter;

  @override
  initState() {
    _searchController.addListener(() {
      setState(() {
        filter = _searchController.text;
      });

      _filtered = _todoItems.map((item) => item);
      print(_filtered);
    });

    @override
    void dispose() {
      _searchController.dispose();
      super.dispose();
    }
  }

  void _addTodoItem(todo) {
    setState(() => _todoItems.add(todo));
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete ${_todoItems[index]}?'),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                  child: new Text('Delete'),
                  color: Colors.red,
                  onPressed: () {
                    _removeTodoItem(index);
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        return filter == null || filter == ""
            ? ListTile(
                title: Text(_todoItems[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _pushEditTodoScreen(_todoItems[index], index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _promptRemoveTodoItem(index);
                      },
                    ),
                  ],
                ))
            : ListTile(
                title: Text(_filtered[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _pushEditTodoScreen(_todoItems[index], index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _promptRemoveTodoItem(index);
                      },
                    ),
                  ],
                ));
      },
      itemCount: _todoItems.length,
    );
  }

  Widget _buildTodoItem(String todo, int index) {
    return ListTile(
        title: Text(todo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _pushEditTodoScreen(todo, index);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _promptRemoveTodoItem(index);
              },
            ),
          ],
        ));
  }

  void _pushEditTodoScreen(String todo, int index) {
    _editController.text = todo;
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit todo')),
        body: TextField(
          controller: _editController,
          autofocus: true,
          onSubmitted: (val) {
            _todoItems[index] = val;
            Navigator.of(context).pop();
          },
        ),
      );
    }));
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add todo'),
        ),
        body: TextField(
          autofocus: true,
          onSubmitted: (val) {
            _addTodoItem(val);
            Navigator.pop(context);
          },
          decoration: InputDecoration(
              hintText: 'Enter todo...',
              contentPadding: const EdgeInsets.all(16.0)),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
      appBar: AppBar(
        title: cusSearchBar,
        actions: <Widget>[
          IconButton(
            icon: cusIcon,
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  this.cusIcon = Icon(Icons.cancel);
                  this.cusSearchBar = TextField(
                    controller: _searchController,
                    onChanged: (text) {
                      print(_todoItems.contains(text));
                    },
                  );
                } else {
                  _searchController.text = '';
                  cusIcon = Icon(Icons.search);
                  cusSearchBar = Text('AppBar');
                }
              });
            },
          )
        ],
      ),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }
}
