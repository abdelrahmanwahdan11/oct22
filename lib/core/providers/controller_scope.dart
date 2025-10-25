import 'package:flutter/material.dart';

class ControllerScope extends StatefulWidget {
  const ControllerScope({
    super.key,
    required this.controllers,
    required this.child,
  });

  final Map<Type, ChangeNotifier> controllers;
  final Widget child;

  static T watch<T extends ChangeNotifier>(BuildContext context) {
    final scope =
        InheritedModel.inheritFrom<_ControllerScopeInherited>(context, aspect: T);
    if (scope == null) {
      throw FlutterError.fromParts([
        ErrorSummary('ControllerScope lookup failed'),
        ErrorDescription('Could not find a ControllerScope above the context for $T.'),
      ]);
    }
    final notifier = scope.registry[T];
    if (notifier == null) {
      throw FlutterError('ControllerScope does not contain a controller for type $T.');
    }
    return notifier as T;
  }

  static T read<T extends ChangeNotifier>(BuildContext context) {
    final scope =
        context.getInheritedWidgetOfExactType<_ControllerScopeInherited>();
    if (scope == null) {
      throw FlutterError.fromParts([
        ErrorSummary('ControllerScope lookup failed'),
        ErrorDescription('Could not find a ControllerScope above the context for $T.'),
      ]);
    }
    final notifier = scope.registry[T];
    if (notifier == null) {
      throw FlutterError('ControllerScope does not contain a controller for type $T.');
    }
    return notifier as T;
  }

  @override
  State<ControllerScope> createState() => _ControllerScopeState();
}

class _ControllerScopeState extends State<ControllerScope> {
  late final Map<Type, ChangeNotifier> _controllers;
  late final Map<Type, VoidCallback> _removeListeners;
  late Map<Type, int> _versions;
  int _version = 0;

  @override
  void initState() {
    super.initState();
    _controllers = Map<Type, ChangeNotifier>.unmodifiable(widget.controllers);
    _versions = {for (final type in _controllers.keys) type: 0};
    _removeListeners = {};
    widget.controllers.forEach((type, controller) {
      void listener() => _handleChange(type);
      controller.addListener(listener);
      _removeListeners[type] = () => controller.removeListener(listener);
    });
  }

  @override
  void didUpdateWidget(covariant ControllerScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controllersChanged(widget.controllers, oldWidget.controllers)) {
      return;
    }
    for (final remove in _removeListeners.values) {
      remove();
    }
    _controllers = Map<Type, ChangeNotifier>.unmodifiable(widget.controllers);
    _versions = {for (final type in _controllers.keys) type: 0};
    _removeListeners = {};
    widget.controllers.forEach((type, controller) {
      void listener() => _handleChange(type);
      controller.addListener(listener);
      _removeListeners[type] = () => controller.removeListener(listener);
    });
    _version += 1;
  }

  bool _controllersChanged(
    Map<Type, ChangeNotifier> current,
    Map<Type, ChangeNotifier> previous,
  ) {
    if (current.length != previous.length) return true;
    for (final entry in current.entries) {
      if (!identical(entry.value, previous[entry.key])) {
        return true;
      }
    }
    return false;
  }

  void _handleChange(Type type) {
    setState(() {
      _version += 1;
      _versions = Map<Type, int>.from(_versions)
        ..update(type, (value) => value + 1, ifAbsent: () => 1);
    });
  }

  @override
  void dispose() {
    for (final remove in _removeListeners.values) {
      remove();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ControllerScopeInherited(
      registry: _controllers,
      versions: _versions,
      version: _version,
      child: widget.child,
    );
  }
}

class _ControllerScopeInherited extends InheritedModel<Type> {
  const _ControllerScopeInherited({
    required this.registry,
    required this.versions,
    required this.version,
    required super.child,
  });

  final Map<Type, ChangeNotifier> registry;
  final Map<Type, int> versions;
  final int version;

  @override
  bool updateShouldNotify(_ControllerScopeInherited oldWidget) =>
      version != oldWidget.version;

  @override
  bool updateShouldNotifyDependent(
    _ControllerScopeInherited oldWidget,
    Set<Type> dependencies,
  ) {
    for (final dependency in dependencies) {
      final previous = oldWidget.versions[dependency];
      final current = versions[dependency];
      if (previous != current) {
        return true;
      }
    }
    return false;
  }
}

extension ControllerScopeX on BuildContext {
  T watchController<T extends ChangeNotifier>() => ControllerScope.watch<T>(this);

  T readController<T extends ChangeNotifier>() => ControllerScope.read<T>(this);
}
