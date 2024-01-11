import 'package:flutter/material.dart';

import '../../style/style.dart';
import 'network_widget.dart';

class VScaffoldWidget extends StatelessWidget {
  const VScaffoldWidget(
      {required this.scaffoldTitle,
      required this.scaffoldBody,
      this.scaffoldFAB});
  final String scaffoldTitle;
  final Widget scaffoldBody;
  final Widget? scaffoldFAB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Palette.tertiaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            scaffoldTitle,
            style: Themes.customColor(FontWeight.bold, 20, color: Colors.white),
          ),
          toolbarHeight: 45,
          actions: [
            NetworkWidget(),
          ],
        ),
        floatingActionButton: scaffoldFAB,
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.containerBackgroundColor.withOpacity(0.1)),
              padding: EdgeInsets.all(8),
              child: scaffoldBody,
            )));
  }
}
