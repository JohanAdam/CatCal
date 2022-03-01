import 'package:flutter/material.dart';

String imageUri = 'https://yt3.ggpht.com/r_JxOMQqL__JpMhQCjFhlKIVzwMV4O5lhfgzQWAPw_ogUDhUvy7XLH5w80hLGVhM2tmmWWvvHw=s900-c-k-c0x00ffffff-no-rj';

class Page2 extends StatelessWidget {
  const Page2({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
        backgroundColor: Colors.greenAccent
      ),
      body: Hero(
        tag: 'katsu', 
        child: Image.network(imageUri)
      )
    );
  }
}