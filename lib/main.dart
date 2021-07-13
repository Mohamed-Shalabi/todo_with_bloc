import 'package:flutter/material.dart';
import 'package:todo_with_bloc/shared/components/constants.dart';

import 'layout/main_page/main_screen.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
