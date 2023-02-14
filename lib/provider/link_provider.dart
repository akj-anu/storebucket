import 'package:flutter/cupertino.dart';

class LinkProvider extends ChangeNotifier {
  final TextEditingController linkTitleController =
      TextEditingController(text: "");
  final TextEditingController linkController = TextEditingController(text: "");
  List<String> linkList = [];
  List<String> linkNameList = [];
  List<Map<String, String>> linkMap = [];
  String? linkTitleErrorMessage;
  String? linkErrorMessage;

  bool isLinkCorrect = false;
  addLink() async {
    linkMap.add({
      "title": linkTitleController.text.toString(),
      "url": linkController.text.toString()
    });
    linkTitleErrorMessage = null;
    linkErrorMessage = null;
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

  setLinkTitleErrorMessage({String? error}) {
    linkTitleErrorMessage = error;
    notifyListeners();
  }

  setLinkErrorMessage({String? error}) {
    linkErrorMessage = error;
    notifyListeners();
  }

  clearList(){
    linkMap=[];
    notifyListeners();
  }
}
