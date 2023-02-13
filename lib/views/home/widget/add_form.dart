import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/provider/link_provider.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/utils/text_form_feild_input_decoration.dart';
import 'package:storebucket/views/add_project/widgets/add_projects_links_dialog.dart';
import 'package:storebucket/views/add_project/widgets/links_list_widget.dart';
import 'package:storebucket/views/add_project/widgets/select_preview_images_widget.dart';
import 'package:storebucket/views/home/home.dart';

enum ChooseType { doc, project }

class AddForm extends StatefulWidget {
  const AddForm({Key? key}) : super(key: key);

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();

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
  bool isTitleAlreadyExist = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserName();

    super.initState();
  }

  getUserName() async {
    userName = await UserManager.getUser();
    debugPrint(userName);
  }

  final ChooseType? _type = ChooseType.doc;

  snackMsg({Color? color, String? text}) {
    final snackBar = SnackBar(
      backgroundColor: color,
      duration: const Duration(seconds: 1),
      content: Text(text ?? 'DETAILS ADDED TO STORE BUCKET '),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  addData() {
    isTitleAlreadyExist = false;
    for (int i = 0; i < Home.searchDataList!.length; i++) {
      if (title == Home.searchDataList![i].title) {
        /*   setState(() {});*/
        isTitleAlreadyExist = true;
        snackMsg(
            color: Colors.orange,
            text: "Title Already Exist , Try another one ");
      }
    }
  }

  addproject() {
    project
        .add({
          'title': title,
          'description': description,
          'code': code,
          'name': userName,
          'linkmap': context.read<LinkProvider>().linkMap
        })
        .then((value) => {
              snackMsg(color: Colors.green, text: "Project Added"),
            })
        .catchError((error) {
          snackMsg(color: Colors.red, text: "Failed to add project");
          debugPrint("Failed to add project: $error");
        });
  }

  _add() {
    isDoc ? addData() : addproject();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hieght = MediaQuery.of(context).size.height;

/*    if (!isTitleAlreadyExist) {
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
            //  setState(() {});
            }).catchError((error) {
              snackMsg(color: Colors.red, text: "Failed to add data");
              debugPrint("Failed to add user: $error");
            })
          : snackMsg(color: Colors.red, text: "Please Fill All Fields");
    }*/

    return Consumer2<ProjectDataProvider,LinkProvider>(builder: (_, value,linksProvider, __) {
      bool isProject = value.type == ChooseType.project ? true : false;
      return Container(
        height: hieght,
        width: width,
        color: const Color(0xFFDCE2E7),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width,
            height: hieght,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Select category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RadioListTile<ChooseType>(
                        title: const Text(
                          'Add Docs',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black),
                        ),
                        value: ChooseType.doc,
                        groupValue: value.type,
                        onChanged: (ChooseType? t) {
                          value.setType(t!);
                          formKey.currentState!.reset();
                        },
                      ),
                      RadioListTile<ChooseType>(
                        title: const Text(
                          'Add Project',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.black),
                        ),
                        value: ChooseType.project,
                        groupValue: value.type,
                        onChanged: (ChooseType? t) {
                          value.setType(t!);
                          formKey.currentState!.reset();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        isProject ? "Project title" : "Document title",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: _titleController,
                          decoration: const InputDecoration(
                              labelText: "Ex: Flutter",
                              focusColor: Colors.black,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Colors.black)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide(color: Colors.black)),
                              hintStyle: TextStyle(color: Colors.black)),
                          onChanged: (text) {
                            title = text;
                          },
                          validator: (String? v) {
                            if (v == null || v == '') {
                              return "Title can not empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        isProject
                            ? "Project description"
                            : "Document description",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: _discriController,
                          maxLength: null,
                          maxLines: null,
                          decoration: inputDecoration(
                            labelText: isProject
                                ? "Your project description"
                                : "Your document description",
                          ),
                          onChanged: (text) {
                            description = text;
                          },
                          validator: (String? v) {
                            if (v == null || v == '') {
                              return isProject
                                  ? "Project description can not empty"
                                  : "Document description can not empty";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (!isProject)
                        const Text(
                          "Add your code",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      if (!isProject)
                        const SizedBox(
                          height: 15,
                        ),
                      !isProject
                          ? Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                style: const TextStyle(color: Colors.black),
                                controller: _codeController,
                                maxLength: null,
                                maxLines: null,
                                minLines: 1000000,
                                keyboardType: TextInputType.multiline,
                                decoration: inputDecoration(labelText: "Code",contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 10)),
                                onChanged: (text) {
                                  code = text;
                                },
                                validator: (String? v) {
                                  if (v == null || v == '') {
                                    return "Code field can not empty";
                                  }
                                  return null;
                                },
                              ),
                            )
                          : const SizedBox(),
                      if (!isProject) const SelectPreviewImages(),
                      isProject
                          ? SizedBox(
                              height: 35,
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            const AddProjectLinksDialogWidget());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape:const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero
                                    )
                                  ),
                                  icon: const Icon(
                                    Icons.attachment,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Add your links here",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white),
                                  )),
                            )
                          : const SizedBox(
                              height: 30,
                            ),
                      if(isProject)
                        const SizedBox(height: 15,),
                      if(isProject)
                        const Text(
                          "Added links",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      if(isProject)
                        const LinksListWidget(width: double.infinity),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            onPressed: () {
                              if (isProject) {
                                if (formKey.currentState!.validate()) {}
                              } else {
                                if (formKey.currentState!.validate()) {
                                  /* context
                                      .read<ProjectDataProvider>()
                                      .createDocument(
                                      title: _titleController.text,
                                      code: _codeController.text,
                                      description: _discriController.text);*/
                                }
                              }
                            },
                            child: Text(isProject
                                ? "Create Project"
                                : "Create Document")),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
