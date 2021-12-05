import 'package:get/get.dart';
import 'package:home_services/app/models/post_request_model.dart';

import '../../../../common/ui.dart';
import '../../../models/post_request_model.dart';
import '../../../repositories/post_request_repository.dart';

enum PostRequestsLayout { GRID, LIST }

class PostRequestsController extends GetxController {
  PostRequestRepository _post_requestRepository;
  RxBool isLoading = true.obs;
  final categories = <PostRequest>[].obs;
  RxList<PostRequest> postRequests = <PostRequest>[].obs;
  final layout = PostRequestsLayout.LIST.obs;

  PostRequestsController() {
    _post_requestRepository = new PostRequestRepository();
  }

  @override
  Future<void> onInit() async {
    isLoading.value = true;
    await refreshList();
    isLoading.value = false;
    super.onInit();
  }

  Future refreshList({bool showMessage = false}) async {
    isLoading.value = true;
    await getPostRequest();
    isLoading.value = false;
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of categories refreshed successfully".tr));
    }
  }

  Future getPostRequest() async {
    postRequests.value = (await this._post_requestRepository.getPostRequests());
    print("GET POSTS SUCCESS.");
  }
}
