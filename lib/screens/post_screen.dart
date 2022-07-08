import 'package:flutter/material.dart';
import 'package:flutter_provider/model/send_data_model.dart';
import 'package:flutter_provider/network/api_wrapper.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Post Data"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: [
          SizedBox(
            height: 30.0,
          ),
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'title'),
          ),
          SizedBox(
            height: 30.0,
          ),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(hintText: 'body'),
          ),
          SizedBox(
            height: 30.0,
          ),
          ElevatedButton(onPressed: sendData, child: Text("Send Data"))
        ],
      ),
    );
  }

  void sendData() async {
    SendDataModel sendDataModel = SendDataModel();
    sendDataModel.title = titleController.value.text;
    sendDataModel.body = bodyController.value.text;
    sendDataModel.userId = 1;
    bool isSuccess = await ApiWrapper.postData(sendDataModel);
    if (isSuccess) {
      showSnackBar("Data added successfully");
      titleController.text = "";
      bodyController.text = "";
      setState(() {});
    } else {
      showSnackBar("Something went wrong , try again later");
    }
  }

  void showSnackBar(String title) {
    final snackBar = new SnackBar(content: new Text(title));
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
