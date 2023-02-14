import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/views/home/widget/login.dart';
import 'package:storebucket/views/project/project_detail.dart';

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final Stream<QuerySnapshot> _projectStream =
  FirebaseFirestore.instance.collection('project').snapshots();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Row(
          children: const [
            Flexible(
              flex: 1,
              child: Icon(
                Icons.cloud_upload,
                color: Colors.blue,
                size: 30,
              ),
            ),
            Flexible(
              flex: 1,
              child: SizedBox(
                width: 5,
              ),
            ),
            Flexible(
              flex: 2,
              child: Text(
                "STORE BUCKET ",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                      return const Home();
                    }), (route) => false);
              },
              child: const Text("DASHBOARD")),
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
      body: SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Container(
              width: width,
              height: 300,
              color: Colors.blue,
              child: width > 1220
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        top: height * 0.05),
                    child: const Text(
                      "OUR PROJECTS ",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                    ),
                    child: const Text(
                      "UI/UX LINKS AND SOURCE CODE",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              )
                  : const SizedBox(),
            ),
            StreamBuilder(
                stream: _projectStream,
                builder: ((BuildContext context,
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.network(
                        "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                        width: 200,
                        height: 200,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return snapshot.data!.docs.isNotEmpty
                        ? SizedBox(
                      height: height,
                      width: width,
                      child: AlignedGridView.count(
                        padding: EdgeInsets.only(
                            left: height * 0.1,
                            right: width * 0.1,
                            top: height * 0.2,
                            bottom: height * 0.1),
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var project = snapshot.data!.docs[index];
                          return projectTile(context,
                              projectTitle: project['title']!,
                              description: project['description'],
                              uiLinks:"",
                              name: project['name'],
                              linkmap: project['linkmap'],
                              id: snapshot.data!.docs[index].id);
                        },
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.only(
                          left: height * 0.1,
                          right: width * 0.1,
                          top: height * 0.2,
                          bottom: height * 0.1),
                      child: const Center(
                          child: Text(
                            "NO PROJECTS",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )),
                    );
                  }
                  return const CircularProgressIndicator();
                })),
          ],
        ),
      ),
    );
  }

  Widget projectTile(BuildContext context,
      {String? projectTitle,
        String? description,
        String? uiLinks,
        String? id,
        String? name,
        List<dynamic>? linkmap}) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (() {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProjectDetailsScreen(
            title: projectTitle,
            description: description,
            code: uiLinks,
            linkmap: linkmap,
          );
        }));
      }),
      child: Container(
          height: height * 0.2,
          width: width * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color(0xFF000000),
                    offset: Offset.zero,
                    blurRadius: 0.0,
                    spreadRadius: 0.0)
              ],
              color: Colors.white),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.all(height * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Text(
                          projectTitle ?? '',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                        )),
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: height * 0.01,
                        )),
                    Flexible(
                        flex: 3,
                        child: Text(
                          description ?? '',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          textAlign: TextAlign.left,
                        )),
                  ],
                ),
              ),
              Home.username == name
                  ? Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: const Padding(
                              padding: EdgeInsets.all(50.0),
                              child: Text(
                                  'Do you want to delete the project?'),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    _deleteProject(id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete')),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'))
                            ],
                          ));
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red.withOpacity(0.9),
                    )),
              )
                  : const SizedBox(),
            ],
          )),
    );
  }

  _deleteProject(id) {
    FirebaseFirestore.instance
        .collection('project')
        .doc(id)
        .delete()
        .then((value) => log("Project Deleted"))
        .catchError((error) => log("Failed to delete user: $error"));
  }
}
