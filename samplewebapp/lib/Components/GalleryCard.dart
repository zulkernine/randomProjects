import 'package:flutter/material.dart';
import 'dart:math';

import 'package:samplewebapp/Pages/ExhibitionPage.dart';

class GalleryCard extends StatefulWidget {
  final String name;
  final DateTime openFrom;
  final DateTime endTime;
  const GalleryCard(
      {Key? key,
      required this.name,
      required this.openFrom,
      required this.endTime})
      : super(key: key);

  @override
  _GalleryCardState createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  int id = 10;
  @override
  void initState() {
    id = 10 + Random().nextInt(25);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 350, maxWidth: 450, minWidth: 300, minHeight: 200),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ExhibitionPage(
                    title: widget.name,
                  )));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ), //BoxShadow
              BoxShadow(
                color: Colors.white,
                offset: const Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
            image: DecorationImage(
              image: NetworkImage('https://picsum.photos/id/${id}/400/400'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.name,
                style: TextStyle(fontSize: 40, color: Colors.white,shadows: [BoxShadow(
                  color: Colors.black,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),]),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.openFrom.toString() + " - " + widget.endTime.toString(),
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
