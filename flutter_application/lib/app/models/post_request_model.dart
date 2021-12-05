import 'dart:convert';

import 'user_model.dart';
import 'category_model.dart';

import 'parents/model.dart';

List<PostRequest> postRequestFromJson(String str) => List<PostRequest>.from(
    json.decode(str).map((x) => PostRequest.fromJson(x)));

String postRequestToJson(List<PostRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostRequest extends Model {
  PostRequest({
    this.description,
    this.delivredAt,
    this.categoryId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.budget,
    this.files,
    this.to,
    this.category,
  });

  String description;
  DateTime delivredAt;
  int categoryId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  int budget;
  List<String> files;
  dynamic to;
  Category category;

  factory PostRequest.fromJson(Map<String, dynamic> json) => PostRequest(
        description: json["description"],
        delivredAt: DateTime.parse(json["delivred_at"]),
        categoryId: json["category_id"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        budget: json["budget"],
        files: List<String>.from(json["files"].map((x) => x)),
        to: User.fromJson(json["to"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "delivred_at": delivredAt.toIso8601String(),
        "category_id": categoryId,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "budget": budget,
        "files": List<dynamic>.from(files.map((x) => x)),
        "to": to,
        "category": category.toJson(),
      };
}
