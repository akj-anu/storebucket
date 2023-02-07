import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProjectDataProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> projectList = [];

  CollectionReference projectStream =
      FirebaseFirestore.instance.collection('data');

  getProjectData() async {
    projectList = [];
    notifyListeners();
    projectStream.get().then((QuerySnapshot snapshot) {
      if (snapshot != null) {
        projectList.addAll(snapshot.docs);
        notifyListeners();
      } else {
        projectList = [];
        notifyListeners();
      }
    });
  }
}
