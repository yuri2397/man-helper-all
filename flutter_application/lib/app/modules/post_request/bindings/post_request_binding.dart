import 'package:get/get.dart';
import '../controllers/post_request_controller.dart';
import '../controllers/post_requests_controller.dart';

class PostRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRequestController>(
      () => PostRequestController(),
    );
    Get.lazyPut<PostRequestsController>(
      () => PostRequestsController(),
    );
  }
}
