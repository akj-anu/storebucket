import 'package:flutter/cupertino.dart';

class LinkProvider extends ChangeNotifier {
  final TextEditingController linkTitleController =
      TextEditingController(text: "");
  final TextEditingController linkController = TextEditingController(text: "");
  List<String> linkList = [];
  List<String> linkNameList = [];
  List<Map<String, String>> linkMap = [];
  String errorMessage = '';
  bool isLinkCorrect = false;
  addLink() async {
    linkMap.add(
        {linkTitleController.text.toString(): linkController.text.toString()});
    errorMessage = '';
    linkController.clear();
    linkTitleController.clear();

    notifyListeners();
  }

  bool checkEmpty() {
    bool isEmpty = true;
    if (linkTitleController.text != "" && linkController.text != "") {
      isEmpty = false;
    }
    notifyListeners();
    return isEmpty;
  }

  removeLink(int index) {
    linkMap.removeAt(index);
    notifyListeners();
  }
}
