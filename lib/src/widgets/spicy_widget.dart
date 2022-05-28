import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spice/src/form/spicy_form.dart';

import '../context.dart';

abstract class SpicyWidget extends StatefulWidget with SpiceContextMixin {

  SpicyWidget({Key? key}) : super(key: key);

  late SpicyWidgetState state;

  Widget assemble();

  void enable() {}
  void disable() {}

  void rebuild() {
    state.rebuild();
  }

  void registerSubscription(StreamSubscription subscription) {
    state._streamSubscriptions.add(subscription);
  }

  @override
  State<SpicyWidget> createState() => SpicyWidgetState();
}

class SpicyWidgetState extends State<SpicyWidget> {

  final List<StreamSubscription> _streamSubscriptions = List.empty(growable: true);

  void rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    widget.context = context;
    widget.state = this;
    widget.enable();
    super.initState();
  }

  @override
  void dispose() {
    widget.disable();
    for (var element in _streamSubscriptions) {
      element.cancel();
    }
    _streamSubscriptions.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return widget.assemble();
  }
}


