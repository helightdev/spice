import 'dart:convert';

import 'package:bloc/src/bloc.dart';
import 'package:duffer/duffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:spice/spice.dart';
import 'package:spice/src/bloc/bloc_widget.dart';
import 'package:spice/src/form/spicy_form.dart';

void main() {
  IntCubit intCubit = IntCubit();
  BoolCubit boolCubit = BoolCubit();

  runApp(MaterialApp(
    home: Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: intCubit),
          BlocProvider.value(value: boolCubit)
        ],
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                intCubit.increment();
              }, child: const Text("Increment")),
              ElevatedButton(onPressed: () {
                boolCubit.toggle();
              }, child: const Text("Toggle")),
              ExampleWidget()
            ],
          ),
        ),
      )
    ),
  ));
}

class IntCubit extends Cubit<int> {
  IntCubit() : super(0);

  void increment() => emit(state + 1);

}

class BoolCubit extends Cubit<bool> {
  BoolCubit() : super(false);

  void toggle() => emit(!state);
}

class ExampleWidget extends BlocWidget {

  BlocProperty<BoolCubit, bool> toggler = BlocProperty();
  BlocProperty<IntCubit, int> counter = BlocProperty();

  @override
  List<BlocProperty> get properties => [toggler, counter];

  @override
  Widget assemble() {
    return Text("${counter.state}", style: TextStyle(color: toggler.state ? Colors.red : Colors.blue),);
  }

}