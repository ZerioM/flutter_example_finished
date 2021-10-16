class MockHelper {
  static Future<List<String>> mockList(List<String> items) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return items.length >= 60 
        ? []
        : List.generate(20, (index) => "List item ${index + items.length}");
  }
}