class SingleResponse<T> {
  SingleResponse(
    Map<String, dynamic> json,
    T Function(dynamic itemJson) itemConverter,
  ) {
    try {
      item = itemConverter(json);
    } catch (e) {
      throw ('Error when map single response');
    }
  }

  late T item;
}
