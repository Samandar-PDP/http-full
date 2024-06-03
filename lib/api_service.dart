import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_full/album.dart';

const String baseUrl = "https://jsonplaceholder.typicode.com";

abstract class ApiService {
  Future<List<Album>> fetchAllAlbums();
  Future<bool> deleteAlbum(int? id);
  Future<bool> updateAlbum(Album album, int oldId);
  Future<bool> createAlbum(Album album);
}
class ApiServiceImpl extends ApiService {
  @override
  Future<bool> createAlbum(Album album) async {
    try {
      final url = Uri.parse("$baseUrl/comments");
     // final response = await http.post(url, body: album.toJson());
      final body = jsonEncode(album.toJson());
      final response = await http.post(url, body: body);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteAlbum(int? id) async {
    try {
      final url = Uri.parse("$baseUrl/comments/$id");
      final response = await http.delete(url);
      return response.statusCode == 200;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<List<Album>> fetchAllAlbums() async {
    try {
       final response = await http.get(Uri.parse("$baseUrl/comments"));
       if (response.statusCode == 200) {
         final List<dynamic> jsonList = jsonDecode(response.body);
         final List<Album> albums = jsonList.map((jsonItem) {
           return Album.fromJson(jsonItem as Map<String, dynamic>);
         }).toList();
         return albums;
       } else {
         debugPrint('Error');
         return [];
       }
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  @override
  Future<bool> updateAlbum(Album album, int oldId) async {
    try {
      final url = Uri.parse("$baseUrl/comments/$oldId");
      final response = await http.put(url, body: album.toJson());
      return response.statusCode == 200;
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
