import 'package:flutter/material.dart';
import 'package:samplewebapp/Components/PaintingCard.dart';

class ExhibitionPage extends StatefulWidget {
  final String title;
  const ExhibitionPage({Key? key,required this.title}) : super(key: key);

  @override
  _ExhibitionPageState createState() => _ExhibitionPageState();
}

class _ExhibitionPageState extends State<ExhibitionPage> {
  int count = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            for(int i=0;i<10;i++)
              PaintingCard(key: Key(i.toString()),),
          ],
          // crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}


