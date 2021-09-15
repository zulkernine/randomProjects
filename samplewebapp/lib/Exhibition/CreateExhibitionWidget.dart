import 'package:flutter/material.dart';
import 'package:samplewebapp/Exhibition/DragAndDromArtWidget.dart';
import 'package:samplewebapp/Exhibition/SelectDateAndGallery.dart';

class CreateExhibitionWidget extends StatefulWidget {
  const CreateExhibitionWidget({Key? key}) : super(key: key);

  @override
  _CreateExhibitionWidgetState createState() => _CreateExhibitionWidgetState();
}

class _CreateExhibitionWidgetState extends State<CreateExhibitionWidget> {
  int _index = 0;
  List<Widget> _pages = [
    SelectDateAndGallery(),
    DragAndDropArtWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 68.0),
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, -4),
              blurRadius: 4,
              color: Color.fromRGBO(0, 0, 0, 0.05))
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton(onPressed: () {
                if(_index < _pages.length -1){
                  setState(() {
                    _index += 1;
                  });
                }
              }, child: Text("Continue")),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
