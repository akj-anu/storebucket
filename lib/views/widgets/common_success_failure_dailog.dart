import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonAlertDialog {
  static Future<void> showDialogPopUp(
    BuildContext context, {
    required String title,
    required String subTitle,
    required String lottieImage,
    required Color titleColor,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: Transform.scale(
            scale: curve,
            child: Dialog(
              child: Container(
                height: 250,
                width: 300,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: Lottie.asset(
                          lottieImage,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(color: titleColor,fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(subTitle,textAlign: TextAlign.center,)
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    ).timeout(const Duration(seconds: 2), onTimeout: () {
      Navigator.pop(context);
    });
  }
}
