import 'package:flutter/material.dart';

import 'package:storebucket/project/widgets/Hover_card.dart';
// import 'package:html/parser.dart' as htmlparser;
// import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';


// ignore: must_be_immutable
class ProjectDetailsScreen extends StatefulWidget {
  ProjectDetailsScreen({
    Key? key,
    this.code,
    this.description,
    this.title,
    this.linkmap,
  }) : super(key: key);
  String? title;
  String? description;
  String? code;

  List<dynamic>? linkmap = [];

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  List<String> linkList = [];
  List<String> linkNameList = [];


  getLink() async {
    for (var element in widget.linkmap ?? {}) {
      element.forEach((key, value) {
        linkList.add(value);
      });
    }
    print(linkList);
  }

  getLinkName() async {
    for (var element in widget.linkmap ?? {}) {
      element.forEach((key, value) {
        linkNameList.add(key);
      });
    }
  }

  @override
  void initState() {
    getLinkName();
    getLink();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _launchUrl(int index) async {
      final Uri _url = Uri.parse(linkList[index]);

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
    // dom.Document document = htmlparser.parse(htmlData);
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
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
          title: Text(widget.title ?? ''),
          backgroundColor: Colors.grey[850],
          automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              SelectableText(
                widget.description ?? '',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 17, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              const Text(
                'Links',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 150,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 6,
                  ),
                  itemCount: widget.linkmap?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return HoverCard(
                      onTaped: () {
                        _launchUrl(index);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.attachment),
                          SizedBox(height: 10),
                          Text(linkNameList[index].toString().toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
