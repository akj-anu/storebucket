import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/views/home/home.dart';
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

  deleteImagesFromLocal(int i){
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

  Future<bool?>createDocument({
    required String title,
    required String description,
    required String code,
  }) async {
    String userName = await UserManager.getUser();
    String email = await UserManager.getEmail();

    List<String> imageUrls = [];

    if (selectedImages.isNotEmpty) {
      imageUploadedCount=0;
      updateImageUploading(true);
      for (var i in selectedImages) {
        String url = await uploadToStorage(image: i);
        imageUrls.add(url);
        imageUploadedCount = imageUrls.length;
        notifyListeners();
      }
      Future.delayed(const Duration(seconds: 1),()=>updateImageUploading(false)).then((value) => updateDocumentsUploading(true));
    }
    document.add({
      'title': title,
      'description': description,
      'code': code,
      'name': userName,
      'preview_images': imageUrls,
      'create_at': DateTime.now().toIso8601String(),
      'email': email
    }).then((value) {
      updateDocumentsUploading(false);
      updateImageUploading(false);
      return true;
    }).catchError((error) {
      updateDocumentsUploading(false);
      updateImageUploading(false);
      return null;
    });
    return null;
  }
}
