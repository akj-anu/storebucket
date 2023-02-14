import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:storebucket/common/statges.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/views/home/widget/add_form.dart';

class ProjectDataProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> projectList = [];
  List<QueryDocumentSnapshot> searchedDataList = [];
  List<Uint8List> selectedImages = [];

  bool isSearching = false;
  bool isLoading = false;
  bool isImageSelected = false;
  bool isImageUploading = false;
  bool isDocumentsUploading = false;

  int imageUploadedCount = 0;

  /// Firebase Collection Reference
  CollectionReference projectStream =
      FirebaseFirestore.instance.collection('data');
  CollectionReference project =
      FirebaseFirestore.instance.collection('project');
  CollectionReference document = FirebaseFirestore.instance.collection('data');

  updateLoader(bool v) {
    isLoading = v;
    notifyListeners();
  }

  updateSearchLoader(bool v) {
    isSearching = v;
    notifyListeners();
  }

  getProjectData() async {
    projectList = [];
    updateLoader(true);
    projectStream.get().then((QuerySnapshot snapshot) {
      if (snapshot != null) {
        projectList.addAll(snapshot.docs);
        updateLoader(false);
      } else {
        projectList = [];
        updateLoader(false);
      }
    });
  }

  searchData(String? data) {
    if (data == null || data == '') {
      searchedDataList = [];
      notifyListeners();
      return;
    } else {
      searchedDataList = [];
      updateSearchLoader(true);
      projectList.forEach((element) {
        if (element['title']
            .toString()
            .toLowerCase()
            .contains(data.toLowerCase())) {
          searchedDataList.add(element);
        } else {
          updateSearchLoader(true);
        }
      });
    }
  }

  ChooseType type = ChooseType.project;
  setType(ChooseType t) {
    type = t;
    notifyListeners();
  }

  updateImageSelection(bool v) {
    isImageSelected = v;
    notifyListeners();
  }

  deleteImagesFromLocal(int i) {
    selectedImages.removeAt(i);
    notifyListeners();
  }

  pickImages() async {
    Uint8List? image = await ImagePickerWeb.getImageAsBytes();
    if (image != null) {
      selectedImages.add(image);
      updateImageSelection(true);
    }
  }

  Future<String> uploadToStorage({
    required Uint8List image,
  }) async {
    String userName = await UserManager.getUser();
    String date = DateTime.now().toString();
    final storageReference = FirebaseStorage.instance
        .ref(userName)
        .child("images")
        .child("$date.png");
    var uploadTask = storageReference.putData(image);
    String downloadURL = await (await uploadTask).ref.getDownloadURL();
    return downloadURL;
  }

  updateDocumentsUploading(bool v) {
    isDocumentsUploading = v;
    notifyListeners();
  }

  updateImageUploading(bool v) {
    isImageUploading = v;
    notifyListeners();
  }

  Future<Types?> createDocument({
    required String title,
    required String description,
    required String code,
  }) async {
    String userName = await UserManager.getUser();
    String email = await UserManager.getEmail();

    List<String> imageUrls = [];

    if (selectedImages.isNotEmpty) {
      imageUploadedCount = 0;
      updateImageUploading(true);
      for (var i in selectedImages) {
        String url = await uploadToStorage(image: i);
        imageUrls.add(url);
        imageUploadedCount = imageUrls.length;
        notifyListeners();
      }
      Future.delayed(
              const Duration(seconds: 1), () => updateImageUploading(false))
          .then((value) => updateDocumentsUploading(true));
    }
    updateDocumentsUploading(true);
    return await document.add({
      'title': title,
      'description': description,
      'code': code,
      'name': userName,
      'preview_images': imageUrls,
      'create_at': DateTime.now().toIso8601String(),
      'email': email
    }).then((value) {
      imageUrls = [];
      selectedImages = [];
      isImageSelected=false;
      updateDocumentsUploading(false);
      updateImageUploading(false);
      return Types.success;
    }).catchError((error) {
      if (error.toString() == "Internal errors.") {
        imageUrls = [];
        selectedImages = [];
        isImageSelected=false;
        updateDocumentsUploading(false);
        updateImageUploading(false);
        return Types.server;
      } else {
        imageUrls = [];
        selectedImages = [];
        isImageSelected=false;
        updateDocumentsUploading(false);
        updateImageUploading(false);
        return Types.failed;
      }
    });
  }

  bool isProjectUploading = false;

  updateProjectUploading(bool v) {
    isProjectUploading = v;
    notifyListeners();
  }

  Future<Types?> createProject(
      {required String title,
      required String description,
      required List<Map<String, dynamic>> links}) async {
    String userName = await UserManager.getUser();
    String email = await UserManager.getEmail();

    updateProjectUploading(true);
    return await project.add({
      'title': title,
      'description': description,
      'name': userName,
      'linkmap': links,
      'create_at': DateTime.now().toIso8601String(),
      'email': email
    }).then((value) {
      updateProjectUploading(false);
      return Types.success;
    }).catchError((error) {
      updateProjectUploading(false);
      if (error.toString() == "Internal errors.") {
        return Types.server;
      } else {
        return Types.failed;
      }
    });
  }

  Future<bool> delete(int i, String id) async {
    return await document
        .doc(id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) {
          getProjectData();
      return true;
    }).catchError((error) {
      return false;
    });
  }
}
