import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/provider/link_provider.dart';
import 'package:storebucket/utils/text_form_feild_input_decoration.dart';
import 'package:storebucket/views/responsive_ui/responsive_screen.dart';

import 'links_list_widget.dart';

class AddProjectLinksDialogWidget extends StatefulWidget {
  const AddProjectLinksDialogWidget({Key? key}) : super(key: key);

  @override
  State<AddProjectLinksDialogWidget> createState() =>
      _AddProjectLinksDialogWidgetState();
}

class _AddProjectLinksDialogWidgetState
    extends State<AddProjectLinksDialogWidget> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    View view = View.web;

    if (width <= 500) {
      view = View.mobile;
    } else if (width > 500 && width <= 1024) {
      view = View.tablet;
    } else if (width > 1024) {
      view = View.web;
    }
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 10,
      child: Consumer<LinkProvider>(builder: (_, value, __) {
        switch (view) {
          case View.mobile:
            return Container(
              color: Colors.white,
              width: width,
              height: height,
              margin: const EdgeInsets.fromLTRB(20, 100, 20, 100),
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Link title",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: linkTitleTextForm(
                        value.linkTitleController, "Ex:Flutter website",
                        error: value.linkTitleErrorMessage),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Link",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: linkTitleTextForm(
                        value.linkController, "https://flutter.dev",
                        error: value.linkErrorMessage),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        value.setLinkErrorMessage(error: null);
                        value.setLinkTitleErrorMessage(error: null);
                        if (value.linkTitleController.text.isEmpty) {
                          value.setLinkTitleErrorMessage(
                              error: "Title can not empty");
                          return;
                        }
                        bool check = value.checkEmpty();
                        debugPrint("the test field is  $check");
                        if (value.linkController.text.contains('https://') ||
                            value.linkController.text.contains('http://')) {
                          if (!check) {
                            value.addLink();
                          }
                        } else {
                          value.setLinkErrorMessage(
                              error: "Please enter a valid url");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      child: const Text("Add Link")),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Added links",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: LinksListWidget(
                        width: width,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero)),
                        child: const Text("Save")),
                  ),
                ],
              ),
            );
          case View.tablet:
            return tabAndWebView(600);
          case View.web:
            return tabAndWebView(800);
        }
      }),
    );
  }

  Widget tabAndWebView(double width) {
    return Container(
      color: Colors.white,
      width: width,
      margin: const EdgeInsets.fromLTRB(20, 100, 20, 100),
      padding: const EdgeInsets.all(15),
      child: Consumer<LinkProvider>(builder: (_, value, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            heading(),
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Link title",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: linkTitleTextForm(
                            value.linkTitleController, "Ex:Flutter website",
                            error: value.linkTitleErrorMessage),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Link",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: linkTitleTextForm(
                            value.linkController, "https://flutter.dev",
                            error: value.linkErrorMessage),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            value.setLinkErrorMessage(error: null);
                            value.setLinkTitleErrorMessage(error: null);
                            if (value.linkTitleController.text.isEmpty) {
                              value.setLinkTitleErrorMessage(
                                  error: "Title can not empty");
                              return;
                            }
                            bool check = value.checkEmpty();
                            debugPrint("the test field is  $check");
                            if (value.linkController.text
                                    .contains('https://') ||
                                value.linkController.text.contains('http://')) {
                              if (!check) {
                                value.addLink();
                              }
                            } else {
                              value.setLinkErrorMessage(
                                  error: "Please enter a valid url");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero)),
                          child: const Text("Add Link")),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      "Added links",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    LinksListWidget(
                      width: width,
                    ),
                  ],
                ))
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero)),
                  child: const Text("Save")),
            ),
          ],
        );
      }),
    );
  }

  Widget heading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Add Project Links',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              margin: EdgeInsets.zero,
              decoration:
                  BoxDecoration(border: Border.all(), shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 18)),
        )
      ],
    );
  }

  Widget linkTitleTextForm(TextEditingController controller, String? hint,
      {String? error}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: error != null ? Colors.red : Colors.black, width: 1),
          ),
          height: 48,
          child: TextFormField(
            style: const TextStyle(color: Colors.black),
            controller: controller,
            keyboardType: TextInputType.name,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.left,
            decoration:
                inputDecoration(hintText: hint, isRequiredBorder: false),
            onChanged: (c) {
              // context.read<LinkProvider>().setLinkTitleErrorMessage(error: null);
              // context.read<LinkProvider>().setLinkErrorMessage(error: null);
            },
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          )
      ],
    );
  }
}
