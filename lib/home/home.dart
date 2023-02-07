import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/common/extention.dart';
import 'package:storebucket/common/fontstyle.dart';
import 'package:storebucket/home/widget/add_form.dart';
import 'package:storebucket/home/widget/details.dart';
import 'package:storebucket/home/widget/drawer.dart';
import 'package:storebucket/home/widget/login.dart';
import 'package:storebucket/home/widget/models/details.dart';
import 'package:storebucket/home/widget/search_widget.dart';
import 'package:storebucket/home/widget/update_bottomsheet.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/project/project.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/responsive_ui/responsive_screen.dart';

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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
    return Selector<ProjectDataProvider, List<QueryDocumentSnapshot>>(
        selector: (_, selector) => selector.projectList,
        builder: (_, data, __) {
          return ResponsiveScreen(
              backgroundColor: Colors.grey[50],
              tabletAppBar: AppBar(
                backgroundColor: Colors.grey[850],
                title: SizedBox(
                  width: size.width,
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: size.width * .15,
                        child: Text(
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
                      ),
                      onPressed: () {
                        UserManager.removeuser().then((value) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850]),
                      ),
                      onPressed: () {
                        UserManager.removeuser().then((value) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
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
                /*     actions: [
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
              ],*/
              ),
              drawer: const CustomDrawer(),
              mobileView: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      color: Colors.grey[850],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          width: 500,
                          child: TextFormField(
                              style: const TextStyle(color: Colors.white),
                              controller: _searchController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  suffixIcon: IconButton(
                                      onPressed: () => _searchController.text !=
                                              ""
                                          ? search()
                                          : snackMsg(
                                              text:
                                                  "Please Enter Search Contents",
                                              color: Colors.orange),
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )),
                                  hintText: 'SEARCH',
                                  hintStyle:
                                      const TextStyle(color: Colors.white)),
                              onChanged: (text) {
                                searchElement = text;
                                if (searchElement != "" ||
                                    searchElement.isNotEmpty) {
                                  search();
                                } else {
                                  setState(() {
                                    isDataAdded = true;
                                    searchedData = null;
                                    Home.searchDataList = null;
                                    searchData = null;
                                  });
                                }
                              }),
                        ),
                      ),
                    ),
                    Expanded(
                        child: CustomCardsWidget(
                      data: data,
                    ))
                  ],
                ),
              ),
              tabletView: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Search(),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          children: [
                            Flexible(
                              flex: 4,
                              child: SizedBox(child: AddForm()),
                            ),
                            Flexible(
                                flex: 6,
                                child: CustomCardsWidget(
                                  data: data,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              webView: SizedBox(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    Search(),
                    Expanded(
                      child: SizedBox(
                        width: size.width,
                        child: Row(
                          children: [
                            const Flexible(
                              flex: 3,
                              child: SizedBox(child: AddForm()),
                            ),
                            Flexible(
                                flex: 7,
                                child: CustomCardsWidget(
                                  data: data,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  search() {
    searchedData = Home.searchDataList!
        .where((element) =>
            element.title!.toLowerCase().contains(searchElement.toLowerCase()))
        .toList();
    for (var element in searchedData!) {
      debugPrint(element.title);
    }
    if (searchedData!.isEmpty) {
      isDataAdded = false;
    } else {
      isDataAdded = true;
    }
    debugPrint(searchedData!.length.toString());
    // searchData = FirebaseFirestore.instance
    //     .collection('data')
    //     .where('title',isEqualTo: searchElement)
    //     .get()
    //     .asStream();
    // log(searchData.toString());
    setState(() {});
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

class CustomCardsWidget extends StatelessWidget {
  final List<DocumentSnapshot> data;
  const CustomCardsWidget({Key? key, required this.data}) : super(key: key);

  getCount(size) {
    if (size <= 500 || size > 500 && size <= 700) {
      return 1;
    } else if (size > 700 && size <= 1024) {
      return 2;
    } else if (size > 1024 && size <= 1300) {
      return 3;
    } else if (size > 1300) {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(size.width);
    return SizedBox(
      height: size.height,
      child: Column(
        children: [
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCount(size.width),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: size.width > 700
                      ? 230 / 190
                      : size.width > 500
                          ? 230 / 120
                          : 230 / 70),
              children: data.map((DocumentSnapshot document) {
                return Stack(
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "A",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("User Name"),
                                    Text("@hi,very cool"),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              document['title'].toString().camelCase(),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              document['description'],
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (Home.username == document['name'])
                      Positioned(
                          right: 5,
                          top: 10,
                          child: Center(
                            child: PopupMenuButton(
                                iconSize: 20,
                                itemBuilder: (_) => <PopupMenuItem<String>>[
                                      new PopupMenuItem<String>(
                                          child: const Text('Edit'),
                                          value: 'edit'),
                                      new PopupMenuItem<String>(
                                          child: const Text('Delete'),
                                          value: 'delete'),
                                    ]),
                          ))
                  ],
                );
              }).toList(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }
}
