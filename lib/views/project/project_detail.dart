import 'package:flutter/material.dart';
import 'package:storebucket/common/extention.dart';
import 'package:storebucket/generated/assets.dart';
import 'package:storebucket/views/project/widgets/Hover_card.dart';
import 'package:storebucket/views/responsive_ui/responsive_screen.dart';
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
  // Map<String, PreviewData> datas = {};

  ScrollController controller = ScrollController();

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        setState(() {
          print(controller.position.pixels);
        });
      });
    });
  }

  getCount(width) {
    if (width <= 500) {
      return 2;
    } else if (width > 500 && width <= 720) {
      return 3;
    } else if (width > 720 && width <= 1024) {
      return 4;
    } else if (width > 1024 && width <= 1150) {
      return 5;
    } else if (width > 1150) {
      return 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    print(w);
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
    return ResponsiveScreen(
      mobileView: SizedBox(
        height: h,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            buildSliverAppBar(fontSize: 22),
            titleAndDescriptionWidget(fontSize: 22),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 200 / 160,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemCount: widget.linkmap?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return HoverCard(
                      onTaped: () {
                        _launchUrl(index);
                      },
                      child: cardWidget(index),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      tabletView: SizedBox(
        height: h,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            buildSliverAppBar(fontSize: 30),
            titleAndDescriptionWidget(fontSize: 30),
            SliverToBoxAdapter(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: w <= 720 ? 3 : 4,
                    childAspectRatio: 200 / 160,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemCount: widget.linkmap?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return HoverCard(
                    onTaped: () {
                      _launchUrl(index);
                    },
                    child: cardWidget(index),
                  );
                },
              ),
            )
          ],
        ),
      ),
      webView: Scaffold(
        body: CustomScrollView(
          controller: controller,
          slivers: [
            buildSliverAppBar(
              fontSize: 40,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title ?? '',
                                style: const TextStyle(
                                    fontSize: 70, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 40),
                              const Text(
                                'Description',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                widget.description ?? '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black54),
                              ).avoidOverFlow(maxLine: 3),
                              const SizedBox(height: 30),
                              const Text(
                                'Links',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      Image.asset(
                        Assets.imagesProjectImage,
                        height: 300,
                      )
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      height: 5,
                      color: Colors.blue)
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCount(w),
                      childAspectRatio: 200 / 150,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemCount: widget.linkmap?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return HoverCard(
                      onTaped: () {
                        _launchUrl(index);
                      },
                      child: cardWidget(index),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding cardWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.8),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
              child: const Icon(
                Icons.attachment,
                color: Colors.white,
              )),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(linkNameList[index].toString().toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar({required double fontSize, Widget? child}) {
    return SliverAppBar(
      expandedHeight: child != null ? 360 : 300,
      backgroundColor: Colors.white,
      pinned: true,
      title: controller.hasClients && controller.position.pixels >= 250
          ? Text(
              widget.title ?? "",
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          : null,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: child ??
            Image.asset(
              Assets.imagesProjectImage,
              fit: BoxFit.cover,
            ),
      ),
    );
  }

  SliverToBoxAdapter titleAndDescriptionWidget({required double fontSize}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '',
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
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
            const SizedBox(height: 30),
            const Text(
              'Links',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
