import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/views/home/widget/add_form.dart';
import 'package:storebucket/views/responsive_ui/responsive_screen.dart';
import 'package:tuple/tuple.dart';

class AddProjectOrDocScreen extends StatefulWidget {
  const AddProjectOrDocScreen({Key? key}) : super(key: key);

  @override
  State<AddProjectOrDocScreen> createState() => _AddProjectOrDocScreenState();
}

class _AddProjectOrDocScreenState extends State<AddProjectOrDocScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ResponsiveScreen(
        backgroundColor: const Color(0xFFDCE2E7),
        mobileAppBar: appBar(context, null),
        tabletAppBar: appBar(context, Colors.black),
        webAppBar: appBar(context, Colors.black),
        mobileView: AddProjectOrDocWidget(
          width: width,
        ),
        tabletView: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: AddProjectOrDocWidget(
                  width: 600,
                ),
              )
            ],
          ),
        ),
        webView: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Expanded(
                child: AddProjectOrDocWidget(
                  width: 800,
                ),
              )
            ],
          ),
        ));
  }
}

AppBar appBar(context, Color? textColor) {
  return AppBar(
    backgroundColor:
        textColor != null ? const Color(0xFFDCE2E7) : Colors.grey[850],
    centerTitle: true,
    elevation: 0,
    title: Selector<ProjectDataProvider, ChooseType>(
        selector: (_, selector) => selector.type,
        builder: (_, value, __) {
          return Text(
            value == ChooseType.project ? "Add Project" : "Add Doc",
            style: TextStyle(color: textColor ?? Colors.white),
          );
        }),
  );
}

class AddProjectOrDocWidget extends StatelessWidget {
  final double width;
  const AddProjectOrDocWidget({Key? key, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return Selector<ProjectDataProvider, Tuple5<bool, bool, int, int, bool>>(
        selector: (_, s) => Tuple5(
            s.isImageUploading,
            s.isDocumentsUploading,
            s.imageUploadedCount,
            s.selectedImages.length,
            s.isProjectUploading),
        builder: (_, v, __) {
          return Stack(
            children: [
              SizedBox(
                width: width,
                height: h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(width: width, child: const AddForm()),
                    ),
                  ],
                ),
              ),
              if (v.item1 || v.item2 || v.item5)
                Container(
                  color: Colors.black54,
                  width: width,
                  height: h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: Colors.blue,
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (v.item1)
                        Text(
                          "Images uploading...(${v.item3}/${v.item4})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      if (v.item2 || v.item5)
                        Text(
                          v.item5
                              ? "Project uploading..."
                              : "Document uploading...",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                    ],
                  ),
                )
            ],
          );
        });
  }
}
