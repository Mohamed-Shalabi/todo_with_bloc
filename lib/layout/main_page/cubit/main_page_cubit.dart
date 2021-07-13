import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_bloc/layout/main_page/cubit/main_page_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todo_with_bloc/modules/archived_todos_module/archived_todos_screen.dart';
import 'package:todo_with_bloc/modules/done_todos_module/done_todos_screen.dart';
import 'package:todo_with_bloc/modules/new_todos_module/new_todos_screen.dart';

class MainPageCubit extends Cubit<MainPageStates> {
  MainPageCubit() : super(InitialMainPageState());

  Database? _database;
  var _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(value) {
    _currentIndex = value;
    emit(bottomNavigationStates[value]);
  }

  bool _isBottomSheetShown = false;
  bool get isBottomSheetShown => _isBottomSheetShown;
  set isBottomSheetShown(value) {
    _isBottomSheetShown = value;
    emit(value ? BottomSheetShownState() : BottomSheetNotShownState());
  }

  TextEditingController controller = TextEditingController();
  String _date = DateFormat.yMMMd().format(DateTime.now());
  String get date => _date;
  set date(value) {
    _date = value;
    emit(BottomSheetShownState());
  }

  var _time = TimeOfDay.now();
  get time => _time;
  set time(value) {
    _time = value;
    emit(BottomSheetShownState());
  }

  List<Map>? tasks;

  final screens = [
    NewTodosScreen(),
    DoneTodosScreen(),
    ArchivedTodosScreen(),
  ];
  final bottomNavigationStates = [
    NewTasksSelectedState(),
    DoneTasksSelectedState(),
    ArchivedTasksSelectedState(),
  ];
  final titles = const [
    'New Todos',
    'Done Todos',
    'Archived Todos',
  ];

  static MainPageCubit of(context) => BlocProvider.of<MainPageCubit>(context);

  Future<void> openTasksDatabase() async {
    _database = await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
            )
            .then(
              (value) => emit(CreatedDatabaseState()),
            )
            .catchError(
              (error) => print(error.toString()),
            );
      },
      onOpen: (database) async {
        await getTasksFromDatabase(database);
      },
    ).catchError(
      (error) {
        print(error.toString());
      },
    );
  }

  void insertToDatabase(String text, String date, String time) async {
    await _database?.transaction((txn) async {
      return await txn
          .rawInsert(
        'INSERT INTO Tasks(title, date, time, status) VALUES("$text", "$date", "$time", "")',
      )
          .then(
        (value) {
          print('inserted successfully');
          getTasksFromDatabase(_database!).then((value) => print(tasks));
        },
      ).catchError((error) {
        print(error.toString());
        print('error');
      });
    });
  }

  Future<void> getTasksFromDatabase(Database database) async {
    await database.rawQuery('SELECT * FROM Tasks').then((value) {
      tasks = value;
      print(tasks);
    }).catchError((error) {
      print(error.toString());
    });
    emit(GetTasksFromDatabaeState());
  }
}
