import 'package:flutter/material.dart';
import 'package:todo_with_bloc/layout/main_page/cubit/main_page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_bloc/layout/main_page/cubit/main_page_states.dart';

class NewTodosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainPageCubit, MainPageStates>(
      listener: (context, state) {},
      builder: (BuildContext context, Object? state) {
        return ListView(
          children: List.generate(
            MainPageCubit.of(context).tasks?.length ?? 0,
            (index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(child: Text(MainPageCubit.of(context).tasks![index]['time'])),
                  Expanded(child: Text(MainPageCubit.of(context).tasks![index]['date'])),
                  Expanded(child: Text(MainPageCubit.of(context).tasks![index]['title'])),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
