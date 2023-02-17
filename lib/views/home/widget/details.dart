import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:storebucket/common/ReuseableW_widget.dart';
import 'package:storebucket/common/fontstyle.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/views/home/widget/update_bottomsheet.dart';

// ignore: must_be_immutable
class DocumentDetailsScreen extends StatelessWidget {
  DocumentDetailsScreen(
      {Key? key, this.code, this.description, this.title, this.username,this.images})
      : super(key: key);
  String? title;
  String? description;
  String? code;
  String? username;
  List<dynamic>? images;

  ScrollController imageScrollController=ScrollController();
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: Text(title ?? ''),
        backgroundColor: Colors.grey[850],
        automaticallyImplyLeading: true,
        actions: [
          Home.username == username
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateBottomSheet(
                              title: title ?? '',
                              description: description ?? '',
                              code: code ?? ''),
                        ));
                  },
                  icon: const Icon(Icons.edit))
              : const SizedBox()
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(25.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DESCRIPTION :', maxLines: 1, style: Fontstyle.commonHead),
                const SizedBox(
                  height: 40,
                ),
                SelectableText(
                  description ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text('CODE / LINK :', maxLines: 1, style: Fontstyle.commonHead),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E1E1E),
                        ),
                        alignment: Alignment.centerLeft,
                        width: double.maxFinite,
                        child: SyntaxView(
                          code: code ?? '',
                          syntax: Syntax.DART,
                          syntaxTheme: SyntaxTheme.vscodeDark(),
                          fontSize: 14.0,
                          withZoom: false,
                          withLinesCount: true,
                          expanded: false,
                        ),
                      ),
                    ),
                    Positioned(
                        right: 20,
                        top: 20,
                        child: IconButton(
                            tooltip: "Copy",
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code)).then(
                                    (value) => ReuseableWidget.snackMsg(context,
                                    text: "Code Copied", color: Colors.green),
                              );
                            },
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.white,
                            )))
                  ],
                ),


              ],
            ),
          ),
          if(images!=null)
            SizedBox(
              height: 400,
              width: width,
              child: Scrollbar(
                controller: imageScrollController,
                trackVisibility: true,
                thumbVisibility: true,
                child: ListView.builder(
                    itemCount: images!.length,
                    controller: imageScrollController,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    itemBuilder: (_,i){
                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(images![i],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          if(images!=null)
            const SizedBox(height: 100,),
        ],
      ),
    );
  }
}
