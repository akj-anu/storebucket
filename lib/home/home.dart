import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:storebucket/home/widget/add_form.dart';
import 'package:storebucket/home/widget/details.dart';
import 'package:storebucket/home/widget/login.dart';
import 'package:storebucket/home/widget/models/details.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/project/project.dart';

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
    super.initState();
  }

  getUserName() async {
    Home.username = await UserManager.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Hi , ${Home.username}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.topRight,
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
                  ),
                ],
              ),
              Row(
                children: [
                  const Flexible(flex: 5, child: AddForm()),
                  Flexible(
                    flex: 20,
                    child: searchedData == null || searchedData!.isEmpty
                        ? Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.indigo[50],
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _usersStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                    
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }
                                if (snapshot.error != null) {
                                  return const Text('snapshot.error');
                                }
                                if (snapshot.stackTrace != null) {
                                  return const Text('Stacktrace.error');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Lottie.network(
                                      "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                                      width: 200,
                                      height: 200,
                                    ),
                                  );
                                }

                                if (snapshot.hasData) {
                                  log(snapshot.data!.docs.toString());
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          // color: Colors.red,
                                          width: double.infinity,
                                          height: 50,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: const [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Text(
                                                          'List of Documents',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                !isDataAdded
                                                    ? Flexible(
                                                        flex: 2,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Text(
                                                              'Entered keyword is not found',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Lottie.network(
                                                                "https://assets2.lottiefiles.com/packages/lf20_shvej97v.json",
                                                                width: 50,
                                                                height: 50),
                                                          ],
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ])),
                                      snapshot.data!.docs.isNotEmpty
                                          ? Expanded(
                                              child: ListView(
                                                children: snapshot.data!.docs
                                                    .map((DocumentSnapshot
                                                        document) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;
                                                  Home.searchDataList = snapshot
                                                      .data!.docs
                                                      .map((doc) => SearchData(
                                                          title: doc['title'],
                                                          description: doc[
                                                              'description'],
                                                          code: doc['code'],
                                                          name: doc['name'],
                                                          id: doc.id))
                                                      .toList();
                                                  return Container(
                                                    //  margin: EdgeInsets.only(right:MediaQuery.of(context).size.width*0.5),
                                                    decoration: BoxDecoration(
                                                        // color: Colors.grey[100],
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    margin: EdgeInsets.only(
                                                        bottom: 5,
                                                        left: 10,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5),

                                                    child: ListTile(
                                                      title:
                                                          Text(data['title']),
                                                      subtitle: Text(
                                                          data['description']),
                                                      // trailing: Text(data['code']),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailsScreen(
                                                            code: data['code'],
                                                            title:
                                                                data['title'],
                                                            description: data[
                                                                'description'],
                                                          ),
                                                        ));
                                                        Home.codeDetails =
                                                            data['code'];
                                                        Home.descriptionDetails =
                                                            data['description'];
                                                        Home.titleDetails =
                                                            data['title'];
                                                        setState(() {
                                                          debugPrint(
                                                              'data id ${data.keys}');
                                                        });
                                                      },
                                                      trailing: Home.username ==
                                                              data['name']
                                                          ? IconButton(
                                                              icon: const Icon(Icons
                                                                  .delete_outline),
                                                              onPressed: (() {
                                                                deleteData(
                                                                    title: data[
                                                                        'title']);
                                                              }))
                                                          : const SizedBox(),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 100,
                                                ),
                                                child: Lottie.network(
                                                    "https://assets2.lottiefiles.com/packages/lf20_shvej97v.json",
                                                    width: 250,
                                                    height: 250),
                                                // const Text(
                                                //   'No search data :(',
                                                //   style: TextStyle(fontSize: 22),
                                                // )
                                              ),
                                            ),
                                    ],
                                  );
                                }
                                return Center(
                                  child: Lottie.network(
                                    "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                                    width: 200,
                                    height: 200,
                                  ),
                                );
                              },
                            ))
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.indigo[50],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      top: 14, left: 15, right: 15),
                                  child: const Text(
                                    'List of Documents',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                searchedData != null || searchedData!.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                            itemCount: searchedData!.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    // color: Colors.grey[100],
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                margin: EdgeInsets.only(
                                                    bottom: 5,
                                                    left: 10,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5),
                                                child: ListTile(
                                                  title: Text(
                                                      searchedData![index]
                                                          .title!),
                                                  subtitle: Text(
                                                      searchedData![index]
                                                          .description!),
                                                  // trailing: Text(data['code']),
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailsScreen(
                                                        code:
                                                            searchedData![index]
                                                                .code!,
                                                        title:
                                                            searchedData![index]
                                                                .title!,
                                                        description:
                                                            searchedData![index]
                                                                .description!,
                                                      ),
                                                    ));
                                                    Home.codeDetails =
                                                        searchedData![index]
                                                            .code!;
                                                    Home.descriptionDetails =
                                                        searchedData![index]
                                                            .description!;
                                                    Home.titleDetails =
                                                        searchedData![index]
                                                            .title!;
                                                    setState(() {});
                                                  },
                                                  trailing: Home.username ==
                                                          searchedData![index]
                                                              .name
                                                      ? IconButton(
                                                          icon: const Icon(Icons
                                                              .delete_outline),
                                                          onPressed: (() {
                                                            deleteData();
                                                          }))
                                                      : const SizedBox(),
                                                ),
                                              );
                                            }))
                                    : Center(
                                        child: Lottie.network(
                                          "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                                          width: 200,
                                          height: 200,
                                        ),
                                      )
                              ],
                            ),
                          ),
                  )
                ],
              )
            ],
          ),
        ));
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
