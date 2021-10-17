import 'dart:convert';

import 'package:http/http.dart' as http;

class Http {

  var client = http.Client();
  String baseURL = 'https://ec2b-81-5-228-154.ngrok.io/';

  Future<List<Item>> getItems() async {
    final response = await client.get(Uri.parse(baseURL + 'items'));

    if(response.statusCode == 200) {
      return Item.getListOfItems(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load album.");
    }
  }

  Future<bool> addItem(String newTitle) async {
    Item newItem = Item(title: newTitle);
    final String json = jsonEncode(newItem.toJson());
    final String url = baseURL + 'items/';

    final response = await client.post(Uri.parse(url), body: json, headers: { "Content-Type": "application/json" });

    return response.statusCode == 200 ? true : false;
  }

  Future<bool> saveItemById(int id, String newTitle) async {
    Item updateItem = Item(title: newTitle);
    final String json = jsonEncode(updateItem.toJson());
    String url = baseURL + 'items/' + id.toString();

    final response = await client.put(Uri.parse(url), body: json, headers: { "Content-Type": "application/json" });

    return response.statusCode == 200 ? true : false;
  }
}

class Item {
  String title;

  Item({
    required this.title
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(title: json['title']);
  }
 
  static List<Item> getListOfItems(List<dynamic> json){
    List<Item> items = [];

    for (var element in json) {
      items.add(Item.fromJson(element));
    }

    return items;
  }

  Map<String, dynamic> toJson() => {
        'title': title
      };
}