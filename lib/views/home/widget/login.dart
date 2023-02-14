import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:storebucket/utils/text_form_feild_input_decoration.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/managers/shared_preference_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text: "");

  bool isLogging = false;

  updateLogging(bool v) {
    setState(() => isLogging = v);
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.grey[850],
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.network(
                      "https://assets2.lottiefiles.com/packages/lf20_z7DhMX.json",
                      width: 250,
                      height: 250),
                  const Text(
                    'STORE BUCKET',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                    height: 80,
                    width: 500,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        autofocus: true,
                        onSubmitted: ((value) => login()),
                        style: const TextStyle(color: Colors.white),
                        controller: emailController,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        decoration: inputDecoration(
                          hintText: "EMAIL",
                          borderColor: Colors.white
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: isLogging
                            ? (){}
                            : () {
                                login();
                              },
                        style: ElevatedButton.styleFrom(
                          shape:const  RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                          )
                        ),
                        child: isLogging
                            ? const Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.blue,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              )
                            : const Text("LOGIN")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  snackMsg({Color? color, String? text}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: color,
      content: Text(text ?? 'DETAILS ADDED TO STORE BUCKET '),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  login() {
    bool isValidUser = false;
    updateLogging(true);
    FirebaseFirestore.instance
        .collection('AuthUsers')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (emailController.text.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          // print(doc["email"]);
          if (emailController.text == doc["email"]) {
            Home.username = doc["name"];
            UserManager.setUser(doc['name']);
            UserManager.setEmail(doc['email']);
            isValidUser = true;
            updateLogging(false);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (Route<dynamic> route) => false);

            snackMsg(text: "Welcome User ${doc["email"]}", color: Colors.green);
          }
        }
      } else if (emailController.text.isEmpty) {
        updateLogging(false);
        snackMsg(text: "Please Enter Email", color: Colors.orange);
      }
      if (!isValidUser && emailController.text.isNotEmpty) {
        updateLogging(false);
        snackMsg(text: "Not An Authorised User", color: Colors.red);
      }
    });
  }
}
