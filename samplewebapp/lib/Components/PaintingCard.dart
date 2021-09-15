import 'dart:math';
import 'package:flutter/material.dart';

class PaintingCard extends StatefulWidget {
  const PaintingCard({Key? key}) : super(key: key);

  @override
  _PaintingCardState createState() => _PaintingCardState();
}

class _PaintingCardState extends State<PaintingCard> {
  bool isLiked = false;
  int id = 1;

  @override
  void initState() {
    id = 1020 + Random().nextInt(60);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool isMobile = _size.width < 500;
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(
          vertical: 20, horizontal: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            'https://picsum.photos/id/${id}/1920/1080',
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, obj, stackTrace) {
              return Center(child: Text("Couldn't load the image 🥲"));
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      !isLiked
                          ? Icons.favorite_border_outlined
                          : Icons.favorite,
                      color: Colors.redAccent,
                      size: 50,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
