import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/common/extention.dart';
import 'package:storebucket/provider/link_provider.dart';

class LinksListWidget extends StatelessWidget {
  final double width;
  const LinksListWidget({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LinkProvider>(builder: (_, value, __) {
      return SizedBox(
        height: 250,
        child: ListView.builder(
          itemCount: value.linkMap.length,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(10),
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.linkMap[index]['title'].toString(),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ).avoidOverFlow(),
                      Text(value.linkMap[index]['url'].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black))
                          .avoidOverFlow(maxLine: 2),
                    ],
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        context.read<LinkProvider>().removeLink(index);
                      },
                      child: Container(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              border: Border.all(), shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 15)),
                    ))
              ],
            );
          },
        ),
      );
    });
  }
}
