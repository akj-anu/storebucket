import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:storebucket/common/fontstyle.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';

class UpdateBottomSheet extends StatefulWidget {
  const UpdateBottomSheet(
      {Key? key,
      required this.title,
      required this.description,
      required this.code})
      : super(key: key);

  final String title;
  final String description;
  final String code;
  @override
  State<UpdateBottomSheet> createState() => _UpdateBottomSheetState();
}

class _UpdateBottomSheetState extends State<UpdateBottomSheet> {
  late TextEditingController titlecontoller;
  late TextEditingController desController;
  late TextEditingController codeController;

  String userName = '';

  getUserName() async {
    userName = await UserManager.getUser();
    debugPrint(userName);
  }

  @override
  void initState() {
    getUserName();
    titlecontoller = TextEditingController(text: widget.title);
    desController = TextEditingController(text: widget.description);
    codeController = TextEditingController(text: widget.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text('Update Details'),
      ),
      body: Container(
        padding: const EdgeInsets.all(50),
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Title :',
                textAlign: TextAlign.left, style: Fontstyle.commonHead),
            const SizedBox(height: 15),
            CustomField(
              contoller: titlecontoller,
            ),
            const SizedBox(height: 15),
            Text('Description :',
                textAlign: TextAlign.left, style: Fontstyle.commonHead),
            const SizedBox(height: 15),
            CustomField(contoller: desController),
            const SizedBox(height: 15),
            Text('Code :',
                textAlign: TextAlign.left, style: Fontstyle.commonHead),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                maxLines: null,
                maxLength: null,
                controller: codeController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ),
            const SizedBox(height: 15),
            InkWell(
                onTap: () async {
                  await updateData(title: widget.title);
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: const Text('Update',
                      style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black87),
                ))
          ],
        ),
      ),
    );
  }

  updateData({title}) {
    String id = "";

    for (int i = 0; i < Home.searchDataList!.length; i++) {
      if (title == Home.searchDataList![i].title) {
        id = Home.searchDataList![i].id!;
      }
    }

    CollectionReference data = FirebaseFirestore.instance.collection('data');

    data
        .doc(id)
        .update({
          'title': titlecontoller.text,
          'description': desController.text,
          'code': codeController.text,
          'name': userName,
        })
        // ignore: avoid_print
        .then((value) => print("Data Updated"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to update data: $error"));
  }
}

class CustomField extends StatelessWidget {
  const CustomField({Key? key, this.contoller}) : super(key: key);
  final TextEditingController? contoller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: contoller,
      decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          hintStyle: TextStyle(color: Colors.black)),
    );
  }
}
