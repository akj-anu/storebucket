import 'package:flutter/material.dart';
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

  final List<Color> colors = <Color>[
    Colors.indigo.shade50,
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.amber.shade50
  ];

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
      appBar: AppBar(
          title: Text(widget.title ?? ''),
          backgroundColor: Colors.grey[850],
          automaticallyImplyLeading: true),
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
                widget.description ?? '',
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
                height: 40,
              ),
              SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 100,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 10,
                  ),
                  itemCount: widget.linkmap?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _launchUrl(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: widget.colors[index % widget.colors.length]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              linkNameList[index].toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
