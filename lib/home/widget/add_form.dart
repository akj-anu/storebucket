import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storebucket/home/home.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/provider/link_provider.dart';

enum ChooseType { doc, project }

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  bool isDoc = true;
  Stream<QuerySnapshot<Object?>>? searchData;
  final TextEditingController _titleController =
      TextEditingController(text: "");
  final TextEditingController _discriController =
      TextEditingController(text: "");
  final TextEditingController _codeController = TextEditingController(text: "");

  CollectionReference users = FirebaseFirestore.instance.collection('data');
  CollectionReference project =
      FirebaseFirestore.instance.collection('project');
  String title = "";
  String description = "";
  String code = "";

  String userName = '';
  bool isAddMore = false;

  @override
  void initState() {
    getUserName();

    super.initState();
  }

  getUserName() async {
    userName = await UserManager.getUser();
    debugPrint(userName);
  }

  ChooseType? _type = ChooseType.doc;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hieght = MediaQuery.of(context).size.height;
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
      title != '' &&
              description != '' &&
              context.read<LinkProvider>().linkMap.isNotEmpty
          ? project
              .add({
                'title': title,
                'description': description,
                'code': code,
                'name': userName,
                'linkmap': context.read<LinkProvider>().linkMap
              })
              .then((value) => {
                    snackMsg(color: Colors.green, text: "Project Added"),
                    context.read<LinkProvider>().linkMap.clear()
                  })
              .catchError((error) {
                snackMsg(color: Colors.red, text: "Failed to add project");
                debugPrint("Failed to add project: $error");
              })
          : snackMsg(color: Colors.red, text: 'Please fill all fields');
    }

    _add() {
      isDoc ? addData() : addproject();
    }

    return Container(
      height: hieght,
      width: width,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioListTile<ChooseType>(
              title: const Text(
                'Add Docs',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
              value: ChooseType.doc,
              groupValue: _type,
              onChanged: (ChooseType? value) {
                setState(() {
                  _type = value;
                  isDoc = true;
                  debugPrint(_type.toString());
                });
              },
            ),
            RadioListTile<ChooseType>(
              title: const Text(
                'Add Project',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
              value: ChooseType.project,
              groupValue: _type,
              onChanged: (ChooseType? value) {
                setState(() {
                  _type = value;
                  isDoc = false;
                  debugPrint(_type.toString());
                });
              },
            ),
            SizedBox(
              height: 80,
              child: TextFormField(
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
            SizedBox(
              height: 80,
              child: TextFormField(
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
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attachment,
                          color: Colors.blue,
                        ),
                        TextButton(
                            onPressed: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => Consumer<LinkProvider>(
                                    builder: (_, value, __) {
                                  return Dialog(
                                    // insetPadding: EdgeInsets.symmetric(
                                    //     horizontal: double.maxFinite),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text('Add Project Links'),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.zero,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        shape: BoxShape.circle),
                                                    child: const Icon(
                                                        Icons.close,
                                                        size: 15)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 80,
                                                      width: 600,
                                                      child: TextField(
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        controller: value
                                                            .linkTitleController,
                                                        maxLength: null,
                                                        maxLines: null,
                                                        decoration: const InputDecoration(
                                                            hintText:
                                                                'Link Title',
                                                            focusColor:
                                                                Colors.black,
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                        // onChanged: (text) {
                                                        //   description = text;
                                                        // },
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 80,
                                                      width: 600,
                                                      child: TextFormField(
                                                        validator: (val) {},
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        controller: value
                                                            .linkController,
                                                        maxLength: null,
                                                        maxLines: null,
                                                        decoration: const InputDecoration(
                                                            hintText: 'Link',
                                                            focusColor:
                                                                Colors.black,
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                    ),
                                                    Text(
                                                      value.errorMessage,
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 30),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  value.linkMap.isNotEmpty
                                                      ? const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 20),
                                                          child: Text(
                                                              'Added Links'),
                                                        )
                                                      : const SizedBox(),
                                                  SizedBox(
                                                    height: 200,
                                                    width: 300,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          value.linkMap.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .indigo[50],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  width: 250,
                                                                  child: Text(
                                                                    value
                                                                        .linkMap[
                                                                            index]
                                                                        .toString()
                                                                        .replaceAll(
                                                                            RegExp('[{-}]'),
                                                                            ''),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  value.removeLink(
                                                                      index);
                                                                },
                                                                child: Container(
                                                                    margin: const EdgeInsets
                                                                        .all(5),
                                                                    decoration: BoxDecoration(
                                                                        border: Border
                                                                            .all(),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                    child: const Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            15)),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    bool check =
                                                        value.checkEmpty();
                                                    debugPrint(
                                                        "the test field is  $check");
                                                    if (value
                                                            .linkController.text
                                                            .contains(
                                                                'https://') ||
                                                        value
                                                            .linkController.text
                                                            .contains(
                                                                'http://')) {
                                                      if (!check) {
                                                        value.addLink();
                                                      }
                                                    } else {
                                                      value.errorMessage =
                                                          'Please Enter Valid URL';
                                                    }
                                                  },
                                                  child:
                                                      const Text("Add Link")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                      "Save and submit")),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                            child: const Text(
                              'Add your project links here',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 30,
                  ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(onPressed: _add, child: Text("ADD ")),
            ),
          ],
        ),
      ),
    );
  }
}
