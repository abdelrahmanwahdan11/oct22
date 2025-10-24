import 'package:flutter/widgets.dart';

class NotifierProvider<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const NotifierProvider({
    super.key,
    required T notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<NotifierProvider<T>>();
    assert(provider != null, 'NotifierProvider<$T> not found in context');
    return provider!.notifier!;
  }

  static T read<T extends ChangeNotifier>(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<NotifierProvider<T>>();
    assert(provider != null, 'NotifierProvider<$T> not found in context');
    return provider!.notifier!;
  }
}
