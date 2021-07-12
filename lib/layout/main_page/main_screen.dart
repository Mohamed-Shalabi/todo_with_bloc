import 'package:flutter/material.dart';
import 'package:todo_with_bloc/layout/main_page/cubit/main_page_cubit.dart';
import 'package:todo_with_bloc/layout/main_page/cubit/main_page_states.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   openTasksDatabase();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainPageCubit>(
      create: (BuildContext context) {
        return MainPageCubit()..openTasksDatabase();
      },
      child: BlocConsumer<MainPageCubit, MainPageStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(MainPageCubit.of(context).titles[MainPageCubit.of(context).currentIndex]),
          ),
          body: MainPageCubit.of(context).screens[MainPageCubit.of(context).currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'New Todos'),
              BottomNavigationBarItem(icon: Icon(Icons.check_box_outlined), label: 'Done Todos'),
              BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'archived Todos'),
            ],
            currentIndex: MainPageCubit.of(context).currentIndex,
            onTap: (int index) {
              // setState(() {
              MainPageCubit.of(context).currentIndex = index;
              // });
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (MainPageCubit.of(context).isBottomSheetShown) {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.pop(context);
                  MainPageCubit.of(context).insertToDatabase(
                    MainPageCubit.of(context).controller.text,
                    MainPageCubit.of(context).date,
                    MainPageCubit.of(context).time.format(context),
                  );
                }
                MainPageCubit.of(context).isBottomSheetShown = false;
              } else {
                _scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) => buildBottomSheet(context),
                      elevation: 15.0,
                    )
                    .closed
                    .then((value) {
                  MainPageCubit.of(context).isBottomSheetShown = false;
                });
                MainPageCubit.of(context).isBottomSheetShown = true;
              }
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Column buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildTitleTextEditing(context),
        Container(
          height: 50.0,
          child: Row(
            children: [
              Expanded(child: buildSelectDate(context)),
              Expanded(child: buildSelectTime(context)),
            ],
          ),
        )
      ],
    );
  }

  Widget buildTitleTextEditing(context) {
    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: TextFormField(
          maxLines: 1,
          controller: MainPageCubit.of(context).controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Title',
            prefixIcon: Icon(Icons.check),
            alignLabelWithHint: true,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          validator: (String? value) {
            if (value?.isEmpty ?? true) {
              return 'title must not be empty';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildSelectDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(
              Duration(days: 365 * 2),
            ),
          ).then((DateTime? value) {
            MainPageCubit.of(context).date = DateFormat.yMMMd().format(value!);
            _scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => buildBottomSheet(context),
                )
                .closed
                .then((value) {
              MainPageCubit.of(context).isBottomSheetShown = false;
            });
            ;
          });
        },
        child: Text(MainPageCubit.of(context).date),
      ),
    );
  }

  Widget buildSelectTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {
          showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
            MainPageCubit.of(context).time = value!;
            _scaffoldKey.currentState!
                .showBottomSheet(
                  (context) => buildBottomSheet(context),
                )
                .closed
                .then((value) {
              MainPageCubit.of(context).isBottomSheetShown = false;
            });
            ;
          });
        },
        child: Text(MainPageCubit.of(context).time.format(context)),
      ),
    );
  }
}
