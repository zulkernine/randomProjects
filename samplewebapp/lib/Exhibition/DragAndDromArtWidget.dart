import 'package:flutter/material.dart';

class DragAndDropArtWidget extends StatefulWidget {
  const DragAndDropArtWidget({Key? key}) : super(key: key);

  @override
  _DragAndDropArtWidgetState createState() => _DragAndDropArtWidgetState();
}

class _DragAndDropArtWidgetState extends State<DragAndDropArtWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Drag and Drop files :)"),),
    );
  }
}

