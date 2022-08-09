import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DetailsScreen extends StatelessWidget {
  DetailsScreen({Key? key, this.code, this.description, this.title})
      : super(key: key);
  String? title;
  String? description;
  String? code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ''),
        backgroundColor: Colors.grey[850],
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DESCRIPTION :',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 15,
              ),
              SelectableText(
                description ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'CODE / LINK :',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 15,
              ),
              SelectableText(
                code ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
