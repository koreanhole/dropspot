extension NullableLetWithElse<T> on T? {
  R letOrElse<R>(R Function(T it) block, {required R Function()? orElse}) {
    if (this != null) {
      return block(this as T);
    } else {
      return orElse?.call() ?? (throw Exception("orElse must not return null"));
    }
  }
}

extension NullableLetExtension<T> on T? {
  R? let<R>(R Function(T it) block) {
    if (this != null) {
      return block(this as T);
    }
    return null;
  }
}
