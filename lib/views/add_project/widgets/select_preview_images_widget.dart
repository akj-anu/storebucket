import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/provider/project_data_provider.dart';

class SelectPreviewImages extends StatelessWidget {
  const SelectPreviewImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    return Consumer<ProjectDataProvider>(builder: (_, values, __) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            values.isImageSelected ? "Selected preview images" : "Add previews",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 15,
          ),
          values.isImageSelected
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio:
                        s.width <= 1024 ? (150 / 200) : (170 / 250),
                    //childAspectRatio:(170/250),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: values.selectedImages.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    if (i < values.selectedImages.length) {
                      Uint8List file = values.selectedImages[i];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.white,
                              height: double.infinity,
                              width: 200,
                              child: Image.memory(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 12,
                              right: 12,
                              child: InkWell(
                                onTap: () {
                                  values.deleteImagesFromLocal(i);
                                  if (values.selectedImages.isEmpty) {
                                    values.updateImageSelection(false);
                                  }
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child: const Center(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black38,
                                  ),
                                ),
                              ))
                        ],
                      );
                    } else {
                      if (i < 5) {
                        return InkWell(
                          onTap: () {
                            context.read<ProjectDataProvider>().pickImages();
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: double.infinity,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.blue, width: 0.8)),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Select images",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const SizedBox(
                      height: 0,
                    );
                  })
              : SizedBox(
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<ProjectDataProvider>().pickImages();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Select Images",
                          ),
                        ],
                      )),
                )
        ],
      );
    });
  }
}
