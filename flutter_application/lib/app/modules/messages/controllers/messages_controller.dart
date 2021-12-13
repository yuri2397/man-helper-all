import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/category_model.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/post_request_repository.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';

class MessagesController extends GetxController {
  final uploading = false.obs;
  var message = Message([]).obs;
  ChatRepository _chatRepository;
  NotificationRepository _notificationRepository;
  AuthService _authService;
  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  File imageFile;
  Rx<DocumentSnapshot> lastDocument = new Rx<DocumentSnapshot>(null);
  final isLoading = true.obs;
  final isDone = false.obs;
  ScrollController scrollController = ScrollController();
  final chatTextController = TextEditingController();
  RxString description = ''.obs;
  RxDouble budget = 0.0.obs;
  RxList<File> files = <File>[].obs;
  RxInt categoryId = (-1).obs;
  Rx<DateTime> delivryTime = DateTime.now().obs;
  CategoryRepository _categoryRepository;
  PostRequestRepository _postRequestRepository;
  RxList<Category> categories = <Category>[].obs;

  MessagesController() {
    _chatRepository = new ChatRepository();
    _notificationRepository = new NotificationRepository();
    _authService = Get.find<AuthService>();
    _categoryRepository = new CategoryRepository();
    _postRequestRepository = new PostRequestRepository();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Pet Car Company'));
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isDone.value) {
        await listenForMessages();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }

  Future createMessage(Message _message) async {
    Get.log(_authService.user.value.id);
    _message.users.insert(0, _authService.user.value);
    _message.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    _message.readByUsers = [_authService.user.value.id];

    message.value = _message;
    print("MESSAGE ON SUBMIT ${message.value}");
    _chatRepository.createMessage(_message).then((value) {
      listenForChats();
    });
  }

  bool validator() {
    if (description.isEmpty || categoryId == -1 || delivryTime.isBlank)
      return false;
    return true;
  }

  Future deleteMessage(Message _message) async {
    messages.remove(_message);
    await _chatRepository.deleteMessage(_message);
  }

  Future refreshMessages() async {
    messages.clear();
    lastDocument = new Rx<DocumentSnapshot>(null);
    await listenForMessages();
  }

  void resetSelectedFile() {
    files = [].obs;
    Get.showSnackbar(Ui.defaultSnackBar(message: "Reset success".tr));
  }

  Future getCategories() async {
    try {
      categories.assignAll(await _categoryRepository.getAllWithSubCategories());
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future chooseFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );

    if (result != null && files.length <= 8) {
      files.addAll(result.paths.map((path) => File(path)).toList());
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: files.length.toString() + " files selected.".tr));
    } else if (result != null && files.length > 8) {
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "Unable to select more than 8 files.".tr));
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Any file selected.".tr));
    }
  }

  Future listenForMessages() async {
    isLoading.value = true;
    isDone.value = false;
    Stream<QuerySnapshot> _userMessages;
    if (lastDocument.value == null) {
      _userMessages =
          _chatRepository.getUserMessages(_authService.user.value.id);
    } else {
      _userMessages = _chatRepository.getUserMessagesStartAt(
          _authService.user.value.id, lastDocument.value);
    }
    _userMessages.listen((QuerySnapshot query) {
      Get.log("QUERY ${query.size}");
      if (query.docs.isNotEmpty) {
        query.docs.forEach((element) {
          var a = Message.fromDocumentSnapshot(element);
          Get.log("MS: " + a.toString());
          messages.add(a);
        });
        lastDocument.value = query.docs.last;
      } else {
        Get.log("EMPTY");
        isDone.value = true;
      }
      isLoading.value = false;
    });
  }

  listenForChats() async {
    message.value = await _chatRepository.getMessage(message.value);
    message.value.readByUsers.add(_authService.user.value.id);
    _chatRepository.getChats(message.value).listen((event) {
      event.forEach((element) {
        Get.log(element.text);
      });
      chats.assignAll(event);
    });
  }

  addMessage(Message _message, String text) {
    Chat _chat = new Chat(text, DateTime.now().millisecondsSinceEpoch,
        _authService.user.value.id, _authService.user.value);

    if (_message.id == null) {
      print("MESSAGE TEXT ${_message.id}");
      _message.id = UniqueKey().toString();
      createMessage(_message);
    }
    _message.lastMessage = text;
    _message.lastMessageTime = _chat.time;
    _message.readByUsers = [_authService.user.value.id];
    uploading.value = false;

    _chatRepository.addMessage(_message, _chat).then((value) {}).then((value) {
      List<User> _users = [];
      _users.addAll(_message.users);
      _users.removeWhere((element) => element.id == _authService.user.value.id);
      _notificationRepository.sendNotification(_users, _authService.user.value,
          "App\\Notifications\\NewMessage", text, _message.id);
    });
  }

  Future getImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile pickedFile;

    pickedFile = await imagePicker.pickImage(source: source);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      try {
        uploading.value = true;
        return await _chatRepository.uploadFile(imageFile);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    } else {
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: "Please select an image file".tr));
    }
  }
}
