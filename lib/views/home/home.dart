import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/views/home/widget/add_form.dart';
import 'package:storebucket/views/home/widget/drawer.dart';
import 'package:storebucket/views/home/widget/home_grid_view_widget.dart';
import 'package:storebucket/views/home/widget/login.dart';
import 'package:storebucket/views/home/widget/models/details.dart';
import 'package:storebucket/views/home/widget/search_widget.dart';
import 'package:storebucket/views/project/project.dart';
import 'package:storebucket/views/responsive_ui/responsive_screen.dart';
import 'package:tuple/tuple.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String titleDetails = '';
  static String descriptionDetails = '';
  static String codeDetails = '';
  static String username = 'Guest';
  static List<SearchData>? searchDataList;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot<Object?>>? searchData;
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('data').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('data');
  final TextEditingController _searchController =
      TextEditingController(text: "");
  String searchElement = "";
  //List<SearchData>? searchDataList;
  List<SearchData>? searchedData;
  bool isDataAdded = true;

  snackMsg({Color? color, String? text}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: color,
      content: Text(text ?? 'DETAILS ADDED TO STORE BUCKET '),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    getUserName();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProjectDataProvider>().getProjectData();
    });
    super.initState();
  }

  getUserName() async {
    Home.username = await UserManager.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ResponsiveScreen(
        backgroundColor: Colors.grey[100],
        tabletAppBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: SizedBox(
            width: size.width,
            child: Row(
              children: [
                const Icon(
                  Icons.cloud_upload,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: size.width * .15,
                  child: const Text(
                    "STORE BUCKET",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            //  ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
            //     ),
            //     onPressed: () {},
            //     child: const Text("DASHBOARD")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const Project();
                  }), (route) => false);
                  // Navigator.push(context, );
                },
                child: const Text("PROJECTS")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  setState(() {
                    isDataAdded = true;
                    searchData = null;
                    searchElement = "";
                    searchedData = null;
                    Home.searchDataList = null;
                    _searchController.text = "";
                  });
                },
                child: const Text("CLEAR")),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                "BETA v1",
                style: TextStyle(color: Colors.white),
              )),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  UserManager.removeuser().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  });
                },
                child: const Text("LOGOUT")),
          ],
        ),
        webAppBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: SizedBox(
            width: size.width,
            child: Row(
              children: const [
                Icon(
                  Icons.cloud_upload,
                  color: Colors.blue,
                  size: 30,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "STORE BUCKET ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          actions: [
            //  ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
            //     ),
            //     onPressed: () {},
            //     child: const Text("DASHBOARD")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return const Project();
                  }), (route) => false);
                  // Navigator.push(context, );
                },
                child: const Text("PROJECTS")),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  setState(() {
                    isDataAdded = true;
                    searchData = null;
                    searchElement = "";
                    searchedData = null;
                    Home.searchDataList = null;
                    _searchController.text = "";
                  });
                },
                child: const Text("CLEAR")),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                "BETA v1",
                style: TextStyle(color: Colors.white),
              )),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                ),
                onPressed: () {
                  UserManager.removeuser().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  });
                },
                child: const Text("LOGOUT")),
          ],
        ),
        mobileAppBar: AppBar(
          backgroundColor: Colors.grey[850],
          centerTitle: true,
          title: Row(
            children: const [
              Icon(
                Icons.cloud_upload,
                color: Colors.blue,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "STORE BUCKET ",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        mobileView: Selector<
                ProjectDataProvider,
                Tuple4<List<QueryDocumentSnapshot>, bool,
                    List<QueryDocumentSnapshot>, bool>>(
            selector: (_, selector) => Tuple4(
                selector.projectList,
                selector.isLoading,
                selector.searchedDataList,
                selector.isSearching),
            builder: (_, data, __) {
              List<QueryDocumentSnapshot> dataList =
                  data.item4 ? data.item3 : data.item1;
              if (data.item2 || data.item1.isEmpty) {
                return Center(
                  child: Lottie.network(
                    "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                    width: 200,
                    height: 200,
                  ),
                );
              }
              return SizedBox(
                width: size.width,
                height: size.height,
                child: Selector<ProjectDataProvider,
                        Tuple5<bool, bool, int, int, bool>>(
                    selector: (_, s) => Tuple5(
                        s.isImageUploading,
                        s.isDocumentsUploading,
                        s.imageUploadedCount,
                        s.selectedImages.length,
                        s.isProjectUploading),
                    builder: (_, v, __) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              Search(width: size.width, hideName: true),
                              const Expanded(
                                child: HomeGridView(),
                              ),
                            ],
                          ),
                          if (v.item1 || v.item2 || v.item5)
                            Container(
                              color: Colors.black54,
                              width: size.width,
                              height: size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      color: Colors.blue,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (v.item1)
                                    Text(
                                      "Images uploading...(${v.item3}/${v.item4})",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (v.item2 || v.item5)
                                    Text(
                                      v.item5
                                          ? "Project uploading..."
                                          : "Document uploading...",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                                ],
                              ),
                            )
                        ],
                      );
                    }),
              );
            }),
        tabletView: SizedBox(
          width: size.width,
          height: size.height,
          child: Selector<ProjectDataProvider,
              Tuple5<bool, bool, int, int, bool>>(
              selector: (_, s) => Tuple5(
                  s.isImageUploading,
                  s.isDocumentsUploading,
                  s.imageUploadedCount,
                  s.selectedImages.length,
                  s.isProjectUploading),
              builder: (_, v, __) {
              return Stack(
                children: [
                  Column(
                    children: [
                      const Search(hideName: false),
                      Expanded(
                        child: SizedBox(
                          width: size.width,
                          child: Row(
                            children: const [
                              Flexible(
                                flex: 4,
                                child: SizedBox(
                                  child: AddForm(),
                                ),
                              ),
                              Flexible(flex: 6, child: HomeGridView()),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if (v.item1 || v.item2 || v.item5)
                    Container(
                      color: Colors.black54,
                      width: size.width,
                      height: size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.blue,
                              strokeWidth: 2.5,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (v.item1)
                            Text(
                              "Images uploading...(${v.item3}/${v.item4})",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          if (v.item2 || v.item5)
                            Text(
                              v.item5
                                  ? "Project uploading..."
                                  : "Document uploading...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                        ],
                      ),
                    )
                ],
              );
            }
          ),
        ),
        webView: SizedBox(
          width: size.width,
          height: size.height,
          child: Selector<ProjectDataProvider,
              Tuple5<bool, bool, int, int, bool>>(
              selector: (_, s) => Tuple5(
                  s.isImageUploading,
                  s.isDocumentsUploading,
                  s.imageUploadedCount,
                  s.selectedImages.length,
                  s.isProjectUploading),
              builder: (_, v, __) {
              return Stack(
                children: [
                  Column(
                    children: [
                      const Search(hideName: false),
                      Expanded(
                        child: SizedBox(
                          width: size.width,
                          child: Row(
                            children: const [
                              Flexible(
                                flex: 3,
                                child: SizedBox(child: AddForm()),
                              ),
                              Flexible(flex: 7, child: HomeGridView()),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  if (v.item1 || v.item2 || v.item5)
                    Container(
                      color: Colors.black54,
                      width: size.width,
                      height: size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.blue,
                              strokeWidth: 2.5,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (v.item1)
                            Text(
                              "Images uploading...(${v.item3}/${v.item4})",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          if (v.item2 || v.item5)
                            Text(
                              v.item5
                                  ? "Project uploading..."
                                  : "Document uploading...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                        ],
                      ),
                    )
                ],
              );
            }
          ),
        ));
  }

  deleteData({title}) {
    String id = "";
    for (int i = 0; i < Home.searchDataList!.length; i++) {
      if (title == Home.searchDataList![i].title) {
        id = Home.searchDataList![i].id!;
      }
    }
    log("Document : " + id);
    FirebaseFirestore.instance
        .collection('data')
        .doc(id)
        .delete()
        .then((value) => log("User Deleted"))
        .catchError((error) => log("Failed to delete user: $error"));
  }
}
