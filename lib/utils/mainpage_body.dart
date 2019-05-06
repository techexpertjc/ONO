import 'package:flutter/material.dart';
import 'package:ono/utils/img_slider.dart';
import 'package:ono/utils/main_tabs.dart';

class MyMainBody extends StatefulWidget {
  @override
  _MyMainBodyState createState() => _MyMainBodyState();
}

class _MyMainBodyState extends State<MyMainBody> {
   static var _saved = Set<String>();
  final snackBar = SnackBar(content: Text('Item already in cart'));
  final snackBar2 = SnackBar(content: Text('added in cart'));

  Widget _buildTile(int i) {
    final alreadySaved = _saved.contains("Item $i");
    return ListTile(
      leading: Container(
          child: Image(
            height:80.0 ,
            width: 80.0,
            image: NetworkImage(
                "https://recipes.timesofindia.com/photo/53109843.cms?imgsize=244340"),
          ),
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.blue,
          ))),
      title: Text("Item $i"),
      subtitle: Text("100₹ "),
      trailing: CircleAvatar(
        backgroundColor: Colors.black,
        child: InkWell(
          child: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              if (alreadySaved) {
                Scaffold.of(context).showSnackBar(snackBar);
              } else {
                _saved.add("Item $i");
                Scaffold.of(context).showSnackBar(snackBar2);
              }
            });
          },
          splashColor: Colors.blueGrey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 230.0,
          child: MySlider(),
        ),
        MyTabs(),
        Divider(
          height: 2.0,
          color: Colors.black,
        ),
        SizedBox(
            height: 500.0,
            child: ListView.builder(
              itemCount: 21,
              itemBuilder: (BuildContext context, int i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                return _buildTile(index);
              },
            ))
      ],
    );
  }
}
