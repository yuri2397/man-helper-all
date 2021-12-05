import 'dart:io';

import 'package:get/get.dart';
import 'package:home_services/app/models/post_request_model.dart';

import '../providers/laravel_provider.dart';

class PostRequestRepository {
  LaravelApiClient _laravelApiClient;

  PostRequestRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future postRequest(String description, String categoryId,
      DateTime delivred_at, int budget, List<File> files) async {
    return this
        ._laravelApiClient
        .postRequest(description, categoryId, delivred_at, budget, files);
  }

  Future<List<PostRequest>> getPostRequests() async {
    return await this._laravelApiClient.getPostRequests();
  }
}
