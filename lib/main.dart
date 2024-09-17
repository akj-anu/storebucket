import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/views/home/widget/login.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';
import 'package:storebucket/provider/link_provider.dart';
import 'package:storebucket/provider/project_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD3PpirA3baJwhhxfmIt0PJ8SXclJlM_kA",
        authDomain: "database-1340b.firebaseapp.com",
        projectId: "database-1340b",
        storageBucket: "database-1340b.appspot.com",
        messagingSenderId: "467604202321",
        appId: "1:467604202321:web:f697ad65fac64d525c2970"),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _init = Firebase.initializeApp();
  String username = '';
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    var u = await UserManager.getUser();
    username = u == "UnknownUser" ? '' : u;
    debugPrint(username);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LinkProvider()),
        ChangeNotifierProvider(create: (context) => ProjectDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'storebucket',
        theme: ThemeData(fontFamily: "Montserrat"),
        /*    home: ProjectDetailsScreen(
        title: "Nest Matrimony",
        description: "Nest",
        linkmap: const [
         {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
         {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
         {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
         {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
         {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Register":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Login":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Home":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Account":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
          {"Settings":"https://xd.adobe.com/view/d2210a85-f229-4d0c-a93d-f009743fb543-8772/"},
        ],
      ), */
        home: FutureBuilder(
            future: _init,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text("ERROR"));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                //    return username == '' ? const LoginScreen() : const Home();
                return username == '' ? const LoginScreen() : const Home();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
