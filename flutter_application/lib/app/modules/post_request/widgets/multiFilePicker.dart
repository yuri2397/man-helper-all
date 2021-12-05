import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import '../controllers/post_request_controller.dart';

// ignore: must_be_immutable
class MultiFilePickerWidget extends GetView<StatelessWidget> {
  MultiFilePickerWidget(
      {@required title, this.onTap, this.onReset, this.filesNumber});
  Function onTap;
  Function onReset;
  String title = "Add new file";
  RxInt filesNumber;
  List<String> files;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 8, bottom: 10, left: 20, right: 20),
        margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5)),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.05))),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: onTap,
                  child: Column(
                    children: [Icon(Icons.add), Text(title)],
                  )),
              SizedBox(width: 8),
              TextButton(
                  onPressed: onReset,
                  child: Column(
                    children: [Icon(Icons.remove), Text("Reset")],
                  )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            filesNumber.value.toString() + " files attached",
            style: TextStyle(
                fontFamily: "Poppins Light",
                color: Theme.of(context).buttonColor),
          )
        ]));
  }
}
