import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spice/src/context.dart';

abstract class BlocWidget extends StatefulWidget with SpiceContextMixin {
  BlocWidget({Key? key}) : super(key: key);

  List<BlocProperty> get properties;

  Widget assemble();

  void enable() {}
  void disable() {}

  @override
  State<BlocWidget> createState() => _BlocWidgetState();
}

class _BlocWidgetState extends State<BlocWidget> {

  late StreamController updates = StreamController.broadcast(sync: true);

  @override
  void initState() {
    widget.context = context;
    for (var property in widget.properties) {
      property._subscribe(context, updates);
    }
    widget.enable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.context = context;
    return StreamBuilder(builder: (_,__) {
      return widget.assemble();
    }, stream: updates.stream);
  }

  @override
  void dispose() {
    widget.disable();
    for (var property in widget.properties) {
      property._dispose();
    }
    super.dispose();
  }
}


class BlocProperty<B extends BlocBase<S>, S> {

  late B bloc;
  late S state;
  late StreamSubscription _subscription;

  void _subscribe(BuildContext context, StreamController controller) {
    bloc = BlocProvider.of<B>(context, listen: false);
    state = bloc.state;
    _subscription = bloc.stream.listen((event) {
      controller.add(event);
      state = event;
    });
  }

  void _dispose() {
    _subscription.cancel();
  }

}