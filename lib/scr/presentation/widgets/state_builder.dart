import 'package:b2b/utilities/logger.dart';
import 'package:flutter/widgets.dart';

/// A convenience widget to rebuild child widget without using Stateful Widget.
///
/// [builder] => return the child widget, which needs to refreshed
///
/// [routeName] => String value for id of parent widget.
///
/// [holder] => a specific String id for a `StateBuilder` widget. If you have more than one builder in a parent widget
/// and you just wanna refresh one of them, set  holder id for it.
///
/// This widget always goes with a `StateHandler` instance as a couple. `StateBuilder` just like
/// a widget wrapper and `StateHandler` will control how and when we need to rebuild the child widget.
/// It means you have to declare a `StateHandler` has same [routeName] with `StateBuilder`.
/// Example:
/// ```dart
/// ...
/// StateHandler _handler = StateHandler('your_screen_widget_route_name');
/// ...
///
///
/// StateBuilder(
///   routeName: 'your_screen_widget_route_name',
///   builder: () => child_widget,
///   holder: 'a_builder_id',
/// )
/// ```
/// and when you need to rebuild the builder, call this function
///
/// ```dart
/// _handler.refresh();
/// ```
/// See also:
///
///  * [StateHandler], which controls the state of a StateBuilder.
///
class StateBuilder extends StatefulWidget {
  const StateBuilder(
      {Key? key, required this.builder, required this.routeName, this.holder})
      : super(key: key);
  final Widget Function() builder;
  final String routeName;
  final String? holder;

  @override
  _StateBuilderState createState() => _StateBuilderState();
}

class _StateBuilderState extends State<StateBuilder> {
  bool reload = false;
  @override
  void initState() {
    super.initState();
    StateHandler.getInstance(widget.routeName)?.register(() {
      setState(() {
        reload = !reload;
      });
    }, hashCode, widget.holder);
  }

  @override
  void dispose() {
    super.dispose();
    StateHandler.getInstance(widget.routeName)?.unRegister(hashCode, widget.holder);
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    // Logger.debug('render widget id=$hashCode ${widget.holder ?? ''}');
    return widget.builder();
  }
}

/// A class to manage state of StateBuilder. This where we register/unregister, set data
/// or rebuild the child widget of the builder.
///
/// [_routeName] => the id to link `StateHandler` and `StateBuilder`. It's required when
/// you using `StateBuilder` and has to declared before declaration of `StateBuilder`.
/// So, normally it always declared as a property of widget.
/// Example:
///
/// ```dart
/// class YourWidget extends StatelessWidget {
/// ...
/// StateHandler _handler = StateHandler('your_screen_widget_route_name');
/// ...
/// }
/// ```
class StateHandler {
  factory StateHandler(String routeName) {
    if(_mState.containsKey(routeName) && _mState[routeName]!=null) {
      return _mState[routeName]!;
    } else {
     final instance = StateHandler._(routeName);
     _mState[routeName] = instance;
     return instance;
    }
  }
  StateHandler._(this._routeName);

  final Map<int, Function?> _mCallbacks = {};
  final Map<String, Function?> _mHolders = {};
  Map<String, dynamic> _mData = {};
  final String _routeName;

  static final Map<String, StateHandler> _mState = {};
  static StateHandler? getInstance(String routeName) {
    return _mState[routeName];
  }

  void register(Function callback, int hashCode, String? holder) {
    _mCallbacks[hashCode] = callback;
    if (holder != null) {
      _mHolders[holder] = callback;
    }
  }

  void unRegister(int hashCode, String? holder) {
    try {
      _mCallbacks.remove(hashCode);
      if(holder!=null) {
        _mHolders.remove(holder);
      }
      if(_mCallbacks.isEmpty && _mHolders.isEmpty) {
        _mState.remove(_routeName);
        _mCallbacks.clear();
        _mHolders.clear();
      }
    } catch(e) {
      Logger.debug(e.toString());
    }
  }

  void setState(Map<String, dynamic>? data) {
    _mData = data ?? {};
    _mCallbacks.forEach((key, value) {
      value?.call();
    });
  }

  void refresh({dynamic holder}) {
    try {
      if (holder != null && _mHolders[holder] != null) {
        _mHolders[holder]?.call();
      } else {
        _mCallbacks.forEach((_key, _value) {
          _value?.call();
        });
      }
    } catch(e) {
      Logger.debug(e.toString());
    }
  }

  Map<String, dynamic> getState() {
    return _mData;
  }

  void setValue(String key, dynamic value) {
    _mData[key] = value;
  }

  String getString(String key) {
    return (_mData[key] ?? '').toString();
  }

  int getInt(String key) {
    return _mData[key];
  }
}
