import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ProjectDetailsScreen extends StatelessWidget {
  ProjectDetailsScreen({Key? key, this.code, this.description, this.title})
      : super(key: key);
  String? title;
  String? description;
  String? code;

  @override
  Widget build(BuildContext context) {
    final Uri _url = Uri.parse('https://flutter.dev');
    Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
    var htmlData = """<div>
  <h1>Demo Page</h1>
  <p>This is a fantastic product that you should buy!</p>
  <h3>Features</h3>
  <ul>
    <li>It actually works</li>
    <li>It exists</li>
    <li>It doesn't cost much!</li>
  </ul>
  <!--You can pretty much put any html in here!-->
</div>""";
    dom.Document document = htmlparser.parse(htmlData);
//       var htmlData = """
// <p id='top'><a href='#'>$code</a></p>
//        <a href='https://www.google.com'>click</a><br>
//        <a href="https://www.w3schools.com">Visit</a>
//       <h1>Header 1</h1>
//       <h2>Header 2</h2>
//       <h3>Header 3</h3>
//       <h4>Header 4</h4>
//       <h5>Header 5</h5>
//       <h6>Header 6</h6>
//       <h3>This is HTML page that we want to integrate with Flutter.</h3>
//       """;
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
                'LINKS:',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(onPressed: _launchUrl, child: Text("click"))
              // SelectableText(
              //   code ?? '',
              //   textAlign: TextAlign.start,
              //   style: const TextStyle(fontSize: 20),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
