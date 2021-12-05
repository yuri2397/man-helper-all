import 'package:flutter/material.dart';
import 'package:home_services/app/modules/post_request/widgets/thumbFile.dart';
import 'package:intl/intl.dart';
import '../../../models/post_request_model.dart';
import '../../../../common/ui.dart';

class PostRequestListItem extends StatelessWidget {
  final PostRequest postRequest;
  final String heroTag;
  final Function onDelete;

  PostRequestListItem({Key key, this.onDelete, this.postRequest, this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(
          border: Border.fromBorderSide(BorderSide.none),
          color: Colors.white,
        ),
        child: Material(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                      onTap: onDelete,
                      child: Icon(Icons.cancel, color: Colors.red)),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    postRequest.category.name,
                    style: TextStyle(fontFamily: "Poppins Bold", fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.av_timer,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Delivry date " +
                        DateFormat("yyyy-MM-dd")
                            .format(postRequest.delivredAt)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.paid_outlined,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Budget \$" + postRequest.budget.toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Description",
                  style: TextStyle(
                      fontFamily: "Poppins Bold", color: Colors.grey[350]),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Text(_subDescription(postRequest.description),
                      textAlign: TextAlign.start),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.attach_file_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      postRequest.files.length.toString() + " files attached.",
                      style: TextStyle(
                          fontFamily: "Poppins Bold", color: Colors.grey[350]),
                    ),
                  ],
                ),
              ],
            )));
  }

  String _subDescription(String description) {
    if (description.length > 350) {
      return description.substring(0, 350) + "...";
    }
    return description;
  }
}
