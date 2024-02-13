import 'package:flutter/material.dart';

class SharedDataWidget extends StatelessWidget {
  final String data;

  SharedDataWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(data);
  }
}

class MyInheritedWidget extends InheritedWidget {
  final String data;

  MyInheritedWidget({required this.data, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return data != oldWidget.data;
  }

  static MyInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;
  }
}
