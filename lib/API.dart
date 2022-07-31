import 'package:dio/dio.dart';

class API {
  static Dio dio = Dio(
    BaseOptions(
      responseType: ResponseType.json,
      baseUrl: "https://random.dog/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: "application/json",
    ),
  );

  static Dio dio2 = Dio(
    BaseOptions(
      responseType: ResponseType.json,
      baseUrl: "https://jsonplaceholder.typicode.com/",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      contentType: "application/json",
    ),
  );
}

class Post {
  int id;
  String title, body;

  Post(this.id, this.title, this.body);

  factory Post.fromMap(Map<String, dynamic> m) => Post(
      int.tryParse(m["id"]?.toString() ?? "0") ?? 0,
      m["title"]?.toString() ?? "",
      m["body"]?.toString() ?? "");
}
