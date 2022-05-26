import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:spice/src/context.dart';
import 'package:spice/src/spicy_form.dart';

import 'form_cubit.dart';


abstract class FormWidget<T> extends StatefulWidget with SpiceContextMixin {

  final String dataKey;
  late FormData data;

  FormCubit get delegate => Provider.of<FormCubit>(context, listen: false);
  T? get value => data.values[dataKey];
  set value(T? value) => delegate.setValue(dataKey, value);

  FormWidget({required this.dataKey}) : super(key: ValueKey(dataKey));

  void reset() {}
  void save() {}
  void enable() {}
  void disable() {}

  Widget build();

  bool needsRebuild(FormData a, FormData b) {
    return a.values[dataKey] != b.values[dataKey];
  }

  @override
  State<FormWidget<T>> createState() => FormWidgetState<T>();
}

class FormWidgetState<T> extends State<FormWidget<T>> {

  late StreamSubscription resetSubscription;
  late StreamSubscription saveSubscription;

  @override
  void initState() {
    var controller = FormController.of(context);
    resetSubscription = controller.resetController.stream.listen((event) => widget.reset());
    saveSubscription = controller.saveController.stream.listen((event) => widget.save());
    widget.enable();
    widget.reset();
    super.initState();
  }


  @override
  void dispose() {
    resetSubscription.cancel();
    saveSubscription.cancel();
    widget.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormCubit, FormData>(builder: ((context, state) {
      widget.context = context;
      widget.data = state;
      return widget.build();
    }), buildWhen: (a,b) {
      return widget.needsRebuild(a, b);
    });
  }
}