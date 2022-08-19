import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storebucket/home/home.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';

enum chooseType { doc, project }

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  List<String> linkList = [];
  bool isDoc = true;
  Stream<QuerySnapshot<Object?>>? searchData;
  final TextEditingController _titleController =
      TextEditingController(text: "");
  final TextEditingController _discriController =
      TextEditingController(text: "");
  final TextEditingController _codeController = TextEditingController(text: "");
  final TextEditingController _linkTitleController =
      TextEditingController(text: "");
  final TextEditingController _linkController = TextEditingController(text: "");
  CollectionReference users = FirebaseFirestore.instance.collection('data');
  CollectionReference project =
      FirebaseFirestore.instance.collection('project');
  String title = "";
  String description = "";
  String code = "";

  String userName = '';
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    userName = await UserManager.getUser();
    debugPrint(userName);
  }

  chooseType? _type = chooseType.doc;
  @override
  Widget build(BuildContext context) {
    snackMsg({Color? color, String? text}) {
      final snackBar = SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        content: Text(text ?? 'DETAILS ADDED TO STORE BUCKET '),
      );
      return ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    addData() {
      bool isTitleAlreadyExist = false;
      for (int i = 0; i < Home.searchDataList!.length; i++) {
        if (title == Home.searchDataList![i].title) {
          setState(() {});
          isTitleAlreadyExist = true;
          snackMsg(
              color: Colors.orange,
              text: "Title Already Exist , Try another one ");
        }
      }

      if (!isTitleAlreadyExist) {
        title != "" && description != "" && code != ""
            ? users.add({
                'title': title,
                'description': description,
                'code': code,
                'name': userName,
              }).then((value) {
                snackMsg(color: Colors.green);
                debugPrint("Data Added");
              }).then((value) {
                _titleController.text = "";
                _discriController.text = "";
                _codeController.text = "";
                title = "";
                description = "";
                code = "";
                setState(() {});
              }).catchError((error) {
                snackMsg(color: Colors.red, text: "Failed to add data");
                debugPrint("Failed to add user: $error");
              })
            : snackMsg(color: Colors.red, text: "Please Fill All Fields");
      }
    }

    addproject() {
      project
          .add({
            'title': title,
            'description': description,
            'code': code,
            'name': userName,
            'links': linkList,
          })
          .then((value) => {
                snackMsg(color: Colors.green, text: "Project Added"),
                setState(() {
                  linkList = [];
                })
              })
          .catchError((error) {
            snackMsg(color: Colors.red, text: "Failed to add project");
            debugPrint("Failed to add project: $error");
          });
    }

    _add() {
      isDoc ? addData() : addproject();
    }

    _addLink() {
      linkList.add(_linkController.text);
      print(linkList);
    }

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<chooseType>(
              title: const Text(
                'Add Docs',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
              value: chooseType.doc,
              groupValue: _type,
              onChanged: (chooseType? value) {
                setState(() {
                  _type = value;
                  isDoc = true;
                  debugPrint(_type.toString());
                });
              },
            ),
            RadioListTile<chooseType>(
              title: const Text(
                'Add Project',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
              value: chooseType.project,
              groupValue: _type,
              onChanged: (chooseType? value) {
                setState(() {
                  _type = value;
                  isDoc = false;
                  debugPrint(_type.toString());
                });
              },

              // activeColor: Colors.white,
            ),

            SizedBox(
              height: 80,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: isDoc ? 'TITLE' : 'PROJECT NAME',
                    focusColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintStyle: const TextStyle(color: Colors.white)),
                onChanged: (text) {
                  title = text;
                },
              ),
            ),
            //  const SizedBox(
            //   height: 10,
            // ),
            SizedBox(
              height: 80,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _discriController,
                maxLength: null,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'DESCRIPTION',
                    focusColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (text) {
                  description = text;
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            !isDoc
                ? SizedBox(
                    height: 80,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _linkTitleController,
                      maxLength: null,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Link Title',
                          focusColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (text) {
                        description = text;
                      },
                    ),
                  )
                : const SizedBox(),
            !isDoc
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(),
            !isDoc
                ? SizedBox(
                    height: 80,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _linkController,
                      maxLength: null,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Link',
                          focusColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white)),
                      onChanged: (text) {
                        description = text;
                      },
                    ),
                  )
                : const SizedBox(),
            !isDoc
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(),
            isDoc
                ? Container(
                    height: 180,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _codeController,
                      maxLength: null,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: isDoc ? 'CODE' : 'UI/UX LINKS AND GIT URL',
                          focusColor: Colors.white,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: const TextStyle(color: Colors.white)),
                      onChanged: (text) {
                        code = text;
                      },
                    ),
                  )
                : const SizedBox(),
            !isDoc
                ? SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: _addLink, child: const Text("ADD LINK")),
                  )
                : const SizedBox(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(onPressed: _add, child: const Text("ADD")),
            ),
          ],
        ),
      ),
    );
  }
}
