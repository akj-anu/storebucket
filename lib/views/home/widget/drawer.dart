import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/common/fontstyle.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/views/home/widget/add_form.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/views/add_project/add_project_or_doc_screen.dart';
import 'package:storebucket/views/home/widget/login.dart';
import 'package:storebucket/views/project/project.dart';

import '../../../managers/shared_preference_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Drawer(
      child: SizedBox(
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: height * .2,
              color: Colors.grey[850],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      maxRadius: width * .07,
                      child: Center(
                        child: Text(
                          Home.username[0],
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Hi , ${Home.username}',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Features",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 1,
                thickness: 0.8,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context);
                context.read<ProjectDataProvider>().getProjectData();
              },
              title: "Home",
              icon: CupertinoIcons.home,
            ),
            CustomListTile(
              onTap: () {
                /*         Navigator.pop(context);
                context.read<ProjectDataProvider>().getProjectData();*/
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const Project();
                }), (route) => false);
              },
              title: "Projects",
              icon: CupertinoIcons.doc_text_search,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context);
                context.read<ProjectDataProvider>().setType(ChooseType.project);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddProjectOrDocScreen()));
              },
              title: "Add Projects",
              icon: CupertinoIcons.plus_rectangle_on_rectangle,
            ),
            CustomListTile(
              onTap: () {
                Navigator.pop(context);
                context.read<ProjectDataProvider>().setType(ChooseType.doc);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddProjectOrDocScreen()));
              },
              title: "Add Docs",
              icon: CupertinoIcons.add_circled,
            ),
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                height: 1,
                thickness: 0.8,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomListTile(
              onTap: () {
                UserManager.removeuser().then((value) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                });
              },
              title: "Logout",
              icon: Icons.logout_outlined,
            ),
            const Spacer(),
            Container(
              height: height * .1,
              color: Colors.black.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.arrow_circle_up_outlined,
                    size: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Beta version",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  const CustomListTile(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);

  final Color iconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: iconColor),
      ),
      onTap: () => onTap(),
      focusColor: iconColor,
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: iconColor,
        size: 15,
      ),
      leading: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}
