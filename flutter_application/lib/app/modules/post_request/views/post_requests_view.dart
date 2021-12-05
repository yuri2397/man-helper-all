import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../widgets/PostRequestListItem.dart';
import '../controllers/post_requests_controller.dart';

class PostRequestsView extends GetView<PostRequestsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage my posts".tr,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshList();
          },
          child: Container(
            child: Obx(() {
              return Offstage(
                  offstage: false,
                  child: controller.postRequests.isEmpty
                      ? CircularLoadingWidget(height: 400)
                      : ListView.builder(
                          itemCount: controller.postRequests.length,
                          itemBuilder: (context, index) {
                            return PostRequestListItem(
                              postRequest: controller.postRequests[index],
                              heroTag: "Post_request_item",
                              onDelete: () async {},
                            );
                          },
                        ));
            }),
          ),
        ));
  }
}
