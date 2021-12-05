import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/repositories/post_request_repository.dart';
import '../../../repositories/category_repository.dart';
import '../../../models/category_model.dart';

import '../../../../common/ui.dart';
import '../../../models/post_request_model.dart';
import '../../../models/e_service_model.dart';

enum PostRequestFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class PostRequestController extends GetxController {
  final post_request = new PostRequest().obs;
  final selected = Rx<PostRequestFilter>(PostRequestFilter.ALL);
  final eServices = <EService>[].obs;
  final dropdownValue = "".obs;
  final dateTitle = "Delivry Time".obs;
  final description = "".obs;
  final budget = 0.obs;
  final categoryId = "".obs;
  final loading = false.obs;
  final disableBtn = true.obs;
  RxList<File> files = <File>[].obs;
  RxInt filesNumber = 0.obs;
  CategoryRepository _categoryRepository;
  PostRequestRepository _postRequestRepository;
  final categories = <Category>[].obs;
  final selectedDate = DateTime.now().obs;

  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  ScrollController scrollController = ScrollController();

  PostRequestController() {
    _categoryRepository = new CategoryRepository();
    _postRequestRepository = new PostRequestRepository();
  }

  @override
  Future<void> onInit() async {
    post_request.value = Get.arguments as PostRequest;
    isLoading.value = true;
    await refreshCategories();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  @override
  void onReady() async {
    await refreshCategories();
    super.onReady();
  }

  Future refreshCategories({bool showMessage = false}) async {
    await getCategories();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of categories refreshed successfully".tr));
    }
  }

  Future postRequest() async {
    print("ID: $categoryId, budget $budget");
    if (validator()) {
      loading.value = true;
      bool res = await _postRequestRepository.postRequest(description.value,
          categoryId.value, selectedDate.value, budget.value, files);
      loading.value = false;
      if (res == true) {
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Your request has been sent.".tr));
      } else {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Your request is not saved.".tr));
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message:
              "Description, categories and delivery date are required.".tr));
    }
  }

  bool validator() {
    if (description.isEmpty ||
        categoryId.isEmpty ||
        selectedDate.isBlank ||
        files.length <= 0) return false;
    return true;
  }

  Future chooseFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: [
        "doc",
        "pdf",
        "docx",
        "zip",
        "png",
        "jpeg",
        "docx",
        "ods",
        "xlsx"
      ],
    );

    if (result != null && files.length <= 8) {
      files.addAll(result.paths.map((path) => File(path)).toList());
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: files.length.toString() + " files selected.".tr));
      filesNumber = files.length.obs;
    } else if (result != null && files.length > 8) {
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "Unable to select more than 8 files.".tr));
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Any file selected.".tr));
    }
  }

  void resetSelectedFile() {
    files = <File>[].obs;
    filesNumber = 0.obs;
    Get.showSnackbar(Ui.defaultSnackBar(message: "Reset success".tr));
  }

  bool isSelected(PostRequestFilter filter) => selected == filter;

  void toggleSelected(PostRequestFilter filter) {
    this.eServices.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = PostRequestFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAll());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
