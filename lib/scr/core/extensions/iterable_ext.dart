extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but callback have index as second argument
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E e, int i) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

extension SafeCast on List {
  List<T>? tryCast<T>() {
    if (this is List<T>) {
      return cast<T>();
    } else {
      return null;
    }
  }
}

extension SafeGetElementAtIndex<T> on List<T> {
  T? safeAt(int? index) {
    if (index != null && -1 < index && index < length) {
      return elementAt(index);
    } else {
      return null;
    }
  }
}
