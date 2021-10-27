import 'dart:convert';
import 'dart:io';
import 'package:example_finished/config/http_config.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

class Http {
  var client = http.Client();
  String baseURL =
      'http://${HttpConfig.ngrokId}.ngrok.io/';
  String imageBaseURL =
      'http://${HttpConfig.ngrokId}.ngrok.io';

  Future<List<Item>> getItems() async {
    final response = await client
        .get(Uri.parse(baseURL + 'items'))
        .catchError((error) => error);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Item.getListOfItems(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load album.");
    }
  }

  Future<bool> addItem(String newTitle, dynamic id, dynamic icon) async {
    var dio = Dio();
    Item newItem = Item(title: newTitle, id: id);
    final String jsonData = jsonEncode(newItem.toJson());

    final itemResponse = await dio.post(baseURL + "items",
        data: jsonData, options: Options(contentType: "application/json"));

  if(icon != null){

    FormData form = FormData.fromMap({

      "files": icon != null ? MultipartFile.fromFileSync(icon.path,
          filename: icon.name, contentType: MediaType('image', 'jpg')): null,
      "refId": itemResponse.data["id"],
      "ref": "items",
      "field": "icon"
    });
    final response = await dio.post(baseURL + "upload",
        data: form, options: Options(contentType: "multipart/form-data"));
  }

    return itemResponse.statusCode == 200 ? true : false;
  }

  Future<bool> saveItemById(int index, String newTitle, dynamic icon) async {
    var dio = Dio();

    Item newItem = Item(title: newTitle, id: index);
    final String jsonData = jsonEncode(newItem.toJson());

    final itemResponse = await dio.put(baseURL + "items/" + index.toString(),
        data: jsonData, options: Options(contentType: "application/json"));

    if(icon != null){

      FormData form = FormData.fromMap({
        "files": MultipartFile.fromFileSync(icon.path,
            filename: icon.name, contentType: MediaType('image', 'jpg')),
        "refId": index,
        "ref": "items",
        "field": "icon"
      });
      final response = await dio.post(baseURL + "upload",
        data: form, options: Options(contentType: "multipart/form-data"));
    }
    return itemResponse.statusCode == 200 ? true : false;
  }

  Future<bool> deleteItemById(int id) async {
    String url = baseURL + 'items/' + id.toString();

    final response = await client.delete(Uri.parse(url));

    return response.statusCode == 200 ? true : false;
  }
}

class Item {
  int id;
  String title;
  late dynamic icon;
  Item({required this.title, required this.id, this.icon});

  factory Item.fromJson(Map<String, dynamic> json) {
    formatImage(json) {
      if (json["icon"] != null) {
        var url = Http().imageBaseURL + json["icon"]["url"];
        // Format image from db to XFile Format
        File image = File.fromUri(Uri.file(url));
        return image;
      }
      return null;
    }

    return Item(title: json['title'], id: json['id'], icon: formatImage(json));
  }

  static List<Item> getListOfItems(List<dynamic> json) {
    List<Item> items = [];

    for (var element in json) {
      items.add(Item.fromJson(element));
    }

    return items;
  }

  convertIcon(XFile icon) async {
    return File(icon.path).readAsBytesSync();
  }

  Map<String, dynamic> toJson() => {'title': title, "id": id};
}
