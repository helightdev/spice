import 'dart:async';

import 'package:duffer/duffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'form_cubit.dart';

export 'form_cubit.dart';
export 'form_widget.dart';

class SpicyForm extends StatefulWidget {

  Widget child;
  late FormController controller;

  @override
  State<SpicyForm> createState() => SpicyFormState();

  SpicyForm({Key? key,
    required this.child,
    FormController? controller
  }) : super(key: key) {
    this.controller = controller ?? FormController();
  }
}

class FormController {

  FormCubit cubit = FormCubit();
  StreamController resetController = StreamController.broadcast(sync: true);
  StreamController saveController = StreamController.broadcast(sync: true);

  Map<String, dynamic> get data {
    save();
    return cubit.state.values;
  }

  String get jsonData {
    save();
    return cubit.state.jsonData;
  }

  ByteBuf get binaryData {
    save();
    return cubit.state.binaryData;
  }

  void reset() => resetController.add(true);
  void save() => saveController.add(true);

  static FormController of(BuildContext context) => Provider.of<FormController>(context, listen: false);

}

class SpicyFormState extends State<SpicyForm> {

  final GlobalKey<FormBuilderState> _formBuilderKey = GlobalKey();
  late StreamSubscription resetSubscription;
  late StreamSubscription saveSubscription;

  @override
  void initState() {
    resetSubscription = widget.controller.resetController.stream.listen((event) => reset());
    saveSubscription = widget.controller.saveController.stream.listen((event) => save());
    super.initState();
  }

  @override
  void dispose() {
    resetSubscription.cancel();
    saveSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      Provider.value(value: widget.controller.cubit),
      Provider.value(value: widget.controller)
    ], child: FormBuilder(
      key: _formBuilderKey,
      child: widget.child,
    ));
  }

  void reset() {
    _formBuilderKey.currentState!.reset();
  }

  void save() {
    _formBuilderKey.currentState!.save();
    for (var element in _formBuilderKey.currentState!.value.entries) {
      widget.controller.cubit.setValue(element.key, element.value);
    }
  }

}
