import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:socket_probe/common/widgets/app_button.dart';
import 'package:socket_probe/core/extensions/navigation_extension.dart';

class Dialogs {
  // show a dialog with a message
  dynamic showInfoDialog(BuildContext context, {required String message}) {
    final size = MediaQuery.sizeOf(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: size.width * 0.5,
            height: size.height * 0.3,
            child: Stack(
              children: [
                // Background blur effect
                // BackdropFilter(
                //   filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                //   child: Container(
                //     color: Colors.black.withValues(alpha: .3),
                //   ),
                // ),
                // Centered loader
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Center(
                          child: Text(message),
                        ),
                        AppButton(
                          content: Text("Ok."),
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Display a loading indicator
  dynamic showLoadingDialog(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            width: size.width * 0.5,
            height: size.height * 0.4,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.black,
                ),
                // backgroundColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
