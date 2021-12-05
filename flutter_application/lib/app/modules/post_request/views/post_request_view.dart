import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/multiFilePicker.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/post_request_controller.dart';

// ignore: must_be_immutable
class PostRequestView extends GetView<PostRequestController> {
  String description;
  String dropdownValue;
  String selectedCategory;
  final defaultDateTitle = "Delivry Time";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Post Request".tr,
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
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshCategories(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWidget(
                  keyboardType: TextInputType.multiline,
                  labelText: "Add description *".tr,
                  hintText: "Max 255 Characters.".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                  onChanged: (value) => controller.description.value = value,
                ),
                TextFieldWidget(
                  keyboardType: TextInputType.numberWithOptions(
                      signed: false, decimal: true),
                  labelText: "Budget Min \$5".tr,
                  hintText: "Budget Min \$5".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                  onChanged: (value) {
                    int v = int.tryParse(value);
                    if (v != null) {
                      controller.budget.value = v;
                    }
                  },
                ),
                Obx(() {
                  return MultiFilePickerWidget(
                    filesNumber: controller.filesNumber,
                    onTap: () async {
                      await controller.chooseFiles();
                    },
                    onReset: () async {
                      await controller.resetSelectedFile();
                    },
                    title: controller.files.length == 0
                        ? "Add new file"
                        : controller.files.length.toString() +
                            "files selected.",
                  );
                }),
                Obx(() {
                  return Offstage(
                    offstage: false,
                    child: controller.isLoading.isTrue
                        ? CircularLoadingWidget(height: 400)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    "Choose a category",
                                    style: Get.textTheme.caption,
                                  ),
                                  trailing: Icon(
                                    Icons.remove,
                                    color:
                                        Get.theme.focusColor.withOpacity(0.3),
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                    hint: Text("Categories",
                                        style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w700)),
                                    decoration: InputDecoration(
                                        disabledBorder: InputBorder.none),
                                    value: dropdownValue,
                                    icon: const Icon(Icons.category,
                                        color: Colors.deepPurple),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    onChanged: (String newValue) {
                                      dropdownValue = newValue;
                                      controller.categoryId.value = newValue;
                                    },
                                    items: controller.categories.map((element) {
                                      return DropdownMenuItem<String>(
                                          child: Text(
                                            element.name,
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                          ),
                                          value: element.id);
                                    }).toList())
                              ]).paddingSymmetric(horizontal: 30),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(
                          "When would you like your service delivered?",
                          style: Get.textTheme.caption,
                        ),
                        trailing: Icon(
                          Icons.remove,
                          color: Get.theme.focusColor.withOpacity(0.3),
                        ),
                      ),
                      TextButton(
                          onPressed: () => _selectDate(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.dateTitle.value,
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.date_range, color: Colors.deepPurple)
                            ],
                          ))
                    ],
                  ).marginSymmetric(horizontal: 30);
                }),
                SizedBox(
                  height: 30,
                ),
                Obx(() {
                  return controller.loading.isTrue
                      ? CircularLoadingWidget(
                          height: 100,
                        )
                      : BlockButtonWidget(
                          onPressed: () async {
                            await controller.postRequest();
                          },
                          color: Get.theme.colorScheme.secondary,
                          text: Text(
                            "Submit Your Request".tr,
                            style: Get.textTheme.headline6.merge(
                                TextStyle(color: Get.theme.primaryColor)),
                          ),
                        ).paddingSymmetric(vertical: 10, horizontal: 20);
                })
              ],
            ),
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate:
            DateTime.parse((DateTime.now().year + 2).toString() + "-01-01"));
    if (picked != null && picked != controller.selectedDate) {
      controller.selectedDate.value = picked;
      controller.dateTitle.value = defaultDateTitle +
          " : " +
          picked.year.toString() +
          "-" +
          picked.month.toString() +
          "-" +
          picked.day.toString();
    }
  }
}
